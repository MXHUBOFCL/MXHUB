#!/usr/bin/env python3
"""MX HUB bundler.

Menggabungkan semua modul di `manifest.json` (urutan penting) menjadi satu file
`MXLIB.lua` di akar repo, siap dipakai lewat loadstring.

    python3 build.py            # tulis MXLIB.lua
    python3 build.py --check    # hanya cek, tidak menulis
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))


def read(path):
    with open(os.path.join(ROOT, path), encoding="utf-8", newline="") as handle:
        return handle.read()


def reindent(text, indent):
    pad = "\t" * indent
    return "\n".join((pad + line) if line.strip() else line for line in text.split("\n"))


def strip_newline(body):
    return body[:-1] if body.endswith("\n") else body


def render(module):
    if "items" in module:
        rows = []
        for path in module["items"]:
            row = strip_newline(read(path))
            if not row.startswith("return "):
                raise SystemExit("%s must start with 'return '" % path)
            rows.append("\t" + row[len("return "):])
        return "local %s = {\n%s\n}" % (module["bind"], ",\n".join(rows) + ",")
    body = strip_newline(read(module["path"]))
    if "bind" in module:
        body, count = re.subn(r"^return ", "local %s = " % module["bind"], body, count=1, flags=re.M)
        if count != 1:
            raise SystemExit("%s has no top-level return" % module["path"])
    return reindent(body, module.get("indent", 0))


def bundle():
    manifest = json.loads(read("manifest.json"))
    return "\n".join(render(module) for module in manifest["modules"])


def main():
    out = bundle()
    if "--check" in sys.argv:
        print("ok: %d bytes, %d lines" % (len(out.encode("utf-8")), out.count("\n") + 1))
        return
    with open(os.path.join(ROOT, "MXLIB.lua"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(out)
    print("MXLIB.lua  %d bytes" % len(out.encode("utf-8")))


if __name__ == "__main__":
    main()
