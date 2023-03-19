# mktmp

[![Tests](https://github.com/marzvrover/mktmp/actions/workflows/tests.yml/badge.svg)](https://github.com/marzvrover/mktmp/actions/workflows/tests.yml)

Make a tempfile that is cleaned up by tmpreaper using crontab to run tmpreaper every minute.

I tried to make this as POSIX compliant as possible with the only additional requirements being `which`, `mktemp`, and `tmpreaper`.

tmpreaper is the Debian package tmpreaper. It is widely available on many operating systems including macOS via [homebrew](https://brew.sh) and [macports](https://www.macports.org/).

## Purpose

I wanted to create an easy way to help people stay in compliance with data retention policies. This is a simple wrapper around mktemp that creates a file in a directory that is cleaned up by tmpreaper every minute. It is still recommended to manually clean up the files after you are done with them, but this provides an addtional layer of protection.

## Installation

Simply move `src/mktmp.sh` to a directory in your `$PATH` as `mktmp` and ensure it is executable.

## Usage

```bash
mktmp <tmpreaper lifespan> [mktemp arguments]
```

The files are created in `/tmp/tmpreaper.$LIFESPAN` and are cleaned up by tmpreaper every minute according to the lifespan.

## Thanks

- [tmpreaper](https://packages.debian.org/source/bullseye/tmpreaper) by [Debian](https://www.debian.org/)
