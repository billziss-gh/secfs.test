#!/usr/bin/python

import re

_re_pl = re.compile(r"^(\d+)..(\d+)")
_re_ok = re.compile(r"^ok (\d+)(.*)")
_re_ko = re.compile(r"^not ok (\d+)(.*)")
def parse(iter):
    pl = None
    ok = set()
    ko = set()
    for line in iter:
        m = _re_pl.search(line)
        if m:
            pl = (int(m.group(1)), int(m.group(2)))
            yield ("PL", pl)
            continue
        m = _re_ok.search(line)
        if m:
            tu = (int(m.group(1)), m.group(2))
            ok.add(tu[0])
            yield ("OK", tu)
            continue
        m = _re_ko.search(line)
        if m:
            tu = (int(m.group(1)), m.group(2))
            ko.add(tu[0])
            yield ("KO", tu)
            continue
        yield ("VV", line)
    if pl is None:
        yield ("RR", "?", ok, ko)
    else:
        yield ("RR", set(xrange(pl[0], pl[1])) - ok - ko, ok, ko)

if "__main__" == __name__:
    import os, subprocess, sys

    def walktree(path):
        if os.path.isdir(path):
            return os.walk(path)
        else:
            return [(os.path.dirname(path), [], [os.path.basename(path)])]
    def write(s):
        global newline
        sys.stdout.write(s)
        newline = False
    def writenl(s):
        global newline
        if not newline and s:
            sys.stdout.write("\n")
        sys.stdout.write(s + "\n")
        newline = True
    def writehead(path):
        write((path + " ").ljust(39, ".") + " ")

    verbose = False
    newline = False
    colors = hasattr(sys.stdout, "isatty") and sys.stdout.isatty() and os.getenv("TERM") == "xterm"
    okstr = "\x1B[32mok\x1B[0m" if colors else "ok"
    kostr = "\x1B[31mnot ok\x1B[0m" if colors else "not ok"
    totals = [0, 0]
    for arg in sys.argv[1:]:
        for dirpath, dirnames, filenames in walktree(arg):
            for filename in filenames:
                if filename.endswith(".t"):
                    filename = os.path.join(dirpath, filename)
                    out = subprocess.check_output([sys.executable, filename],
                        stderr=subprocess.STDOUT, universal_newlines=True)
                    writehead(filename)
                    for i in parse(out.splitlines()):
                        if "RR" == i[0]:
                            if newline:
                                writehead(filename)
                            if not i[1] and not i[3]:
                                write(okstr)
                            else:
                                write(kostr)
                                if i[3]:
                                    write(" %s/%s" % (len(i[3]), len(i[2]) + len(i[3])))
                                if "?" == i[1]:
                                    write(" - test plan missing")
                        elif "PL" == i[0]:
                            if verbose:
                                writenl("%s..%s" % i[1])
                        elif "OK" == i[0]:
                            totals[0] += 1
                            if verbose:
                                writenl(okstr + " %s%s" % i[1])
                        elif "KO" == i[0]:
                            totals[1] += 1
                            writenl(kostr + " %s%s" % i[1])
                        elif "VV" == i[0]:
                            if verbose:
                                writenl("%s" % i[1])
                        else:
                            assert False
                    writenl("")
    if totals[0] + totals[1]:
        writenl("")
        writehead("Totals")
        if totals[0]:
            write("%s %s/%s" % (okstr, totals[0], totals[0] + totals[1]))
        if totals[1]:
            write("%s%s %s/%s" % (" - " if totals[0] else "", kostr, totals[1], totals[0] + totals[1]))
        writenl("")
