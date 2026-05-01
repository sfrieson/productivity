#!/usr/bin/env python3
"""Prints current git context to stdout for the commit skill."""
import subprocess


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()


status = run(["git", "status", "--short"])
staged = run(["git", "diff", "--staged"])
unstaged = run(["git", "diff"])
log = run(["git", "log", "--oneline", "-5"])

print(f"=== Status ===\n{status or '(clean)'}\n")
print(f"=== Recent commits ===\n{log}\n")
if staged:
    print(f"=== Staged diff ===\n{staged}\n")
if unstaged:
    print(f"=== Unstaged diff ===\n{unstaged}\n")
