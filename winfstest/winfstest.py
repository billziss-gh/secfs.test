#!/usr/bin/python

# winfstest.py
#
# Copyright (c) 2015, Bill Zissimopoulos. All rights reserved.
#
# Redistribution  and use  in source  and  binary forms,  with or  without
# modification, are  permitted provided that the  following conditions are
# met:
#
# 1.  Redistributions  of source  code  must  retain the  above  copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions  in binary  form must  reproduce the  above copyright
# notice,  this list  of conditions  and the  following disclaimer  in the
# documentation and/or other materials provided with the distribution.
#
# 3.  Neither the  name  of the  copyright  holder nor  the  names of  its
# contributors may  be used  to endorse or  promote products  derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY  THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND  ANY EXPRESS OR  IMPLIED WARRANTIES, INCLUDING, BUT  NOT LIMITED
# TO,  THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS  FOR  A
# PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT  SHALL THE  COPYRIGHT
# HOLDER OR CONTRIBUTORS  BE LIABLE FOR ANY  DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL   DAMAGES  (INCLUDING,  BUT  NOT
# LIMITED TO,  PROCUREMENT OF SUBSTITUTE  GOODS OR SERVICES; LOSS  OF USE,
# DATA, OR  PROFITS; OR BUSINESS  INTERRUPTION) HOWEVER CAUSED AND  ON ANY
# THEORY  OF LIABILITY,  WHETHER IN  CONTRACT, STRICT  LIABILITY, OR  TORT
# (INCLUDING NEGLIGENCE  OR OTHERWISE) ARISING IN  ANY WAY OUT OF  THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import os, random, subprocess, sys, threading

__all__ = [
    "testline", "testeval", "testdone", "uniqname",
    "fstest", "fstest_task", "expect", "expect_task"]

_ntests = 0
def testline(ok, diag = ""):
    global _ntests
    _ntests += 1
    print "%sok %s%s%s" % ("" if ok else "not ", _ntests, " - " if diag else "", diag)
def testeval(expr):
    f = sys._getframe(1)
    testline(eval(expr, f.f_globals, f.f_locals), expr)
def testdone():
    global _ntests
    print "1..%s" % _ntests
    _ntests = 0

def uniqname():
    return "%08x" % random.randint(1, 2 ** 32)

_fstest_exe = os.path.splitext(os.path.realpath(__file__))[0] + ".exe"
def _fstest_res(out):
    out = out.split("\n")
    res = []
    for l in out[1:]:
        if not l:
            continue
        d = {}
        res.append(d)
        for p in l.split():
            k, v = p.split("=", 2)
            if v.startswith('"') and v.endswith('"') and len(v) >= 2:
                v = v[1:-1]
            else:
                try:
                    v = int(v, 0)
                except:
                    pass
            d[k] = v
    return out[0], res
def _expect(s, cmd, exp, err, res):
    if isinstance(exp, type(_expect)): # function, lambda
        if "0" == err:
            testline(exp(res), "%s \"%s\" %s" % (s, cmd, exp.__name__))
        else:
            testline(0, "%s \"%s\" %s - got %s" % (s, cmd, 0, err))
    else:
        if str(exp) == err:
            testline(1, "%s \"%s\" %s" % (s, cmd, exp))
        else:
            testline(0, "%s \"%s\" %s - got %s" % (s, cmd, exp, err))
def fstest(cmd):
    arg = cmd.split() if hasattr(cmd, "split") else list(cmd)
    out = subprocess.check_output([_fstest_exe] + arg, universal_newlines=True)
    return _fstest_res(out)
def expect(cmd, exp):
    err, res = fstest(cmd)
    _expect("expect", cmd, exp, err, res)
    return err, res

class _fstest_task(object):
    def __init__(self, cmd, exp):
        self.cmd = cmd
        self.exp = exp
        self.out = None
        self.err = None
        self.res = None
        arg = cmd.split() if hasattr(cmd, "split") else list(cmd)
        self.prc = subprocess.Popen([_fstest_exe, "-w"] + arg,
            stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        self.thr = threading.Thread(target=self._readthread)
        self.thr.start()
    def _readthread(self):
        self.out = self.prc.stdout.read()
        self.out = self.out.replace("\r\n", "\n").replace("\r", "\n")
    def __enter__(self):
        pass
    def __exit__(self, type, value, traceback):
        try:
            self.prc.stdin.write("\n")
        except IOError:
            pass
        self.prc.stdin.close()
        self.thr.join()
        self.prc.wait()
        ret = self.prc.poll()
        if ret:
            raise subprocess.CalledProcessError(ret, self.cmd)
        self.err, self.res = _fstest_res(self.out)
        if self.exp is not None:
            _expect("expect_task", self.cmd, self.exp, self.err, self.res)
def fstest_task(cmd):
    return _fstest_task(cmd, None)
def expect_task(cmd, exp):
    if isinstance(exp, type(_expect)): # function, lambda
        print "# expect_task \"%s\" %s" % (cmd, exp.__name__)
    else:
        print "# expect_task \"%s\" %s" % (cmd, exp)
    return _fstest_task(cmd, exp)
