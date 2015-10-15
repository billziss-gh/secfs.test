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

import os, random, subprocess, sys

__all__ = ["testline", "testeval", "testdone", "uniqname", "fstest", "expect"]

ntests = 0
def testline(ok, diag = ""):
    global ntests
    ntests += 1
    print "%sok %s%s%s" % ("" if ok else "not ", ntests, " - " if diag else "", diag)
def testeval(expr):
    f = sys._getframe(1)
    testline(eval(expr, f.f_globals, f.f_locals), expr)
def testdone():
    global ntests
    print "1..%s" % ntests
    ntests = 0

def uniqname():
    return "%08x" % random.randint(1, 2 ** 32)

fstest_exe = os.path.splitext(os.path.realpath(__file__))[0] + ".exe"
def fstest(cmd):
    arg = cmd.split() if hasattr(cmd, "split") else list(cmd)
    out = subprocess.check_output([fstest_exe] + arg, universal_newlines=True)
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
def expect(exp, cmd):
    err, res = fstest(cmd)
    if str(exp) == err:
        testline(1, "expect %s %s" % (exp, cmd))
    else:
        testline(0, "expect %s %s - got %s" % (exp, cmd, err))
    return err, res
