# swift-watch

Watches over your Swift project's source.

---

This is early work in progress. Stay tuned!

# Installation

1. Build
2. Install in `$PATH` (such as in `/usr/local/bin/`)
3. Run `$ cd /path/to/swift/package/`
3. Run `$ swift watch -x build`

# Usage

```
OVERVIEW: Watches over your Swift project's source

Tasks (-x & -s) are executed in the order they appear.

USAGE: swift watch [options]

OPTIONS:
   -c, --clear                   Clear output before each execution
   -d, --dry-run                 Do not run any commands, just print them
   -q, --quiet                   Suppress output from swift-watch itself
   -p, --postpone                Postpone initial execution until the first change
   -m, --monochrome              Suppress coloring of output from swift-watch itself
   -x, --exec=<cmd>              Swift command(s) to execute on changes
   -s, --shell=<cmd>             Shell command(s) to execute on changes
   -h, --help                    The help menu
```

# Roadmap

- [x] Swift commands
- [x] Shell commands
- [x] Colorful output
- [x] Console clearing
- [x] Lazy mode
- [x] Delayed runs
- [x] Quiet mode
- [x] Dry-run mode
- [ ] Ignore patterns
- [ ] Watch patterns

# Shout-out

If you're looking for "just" a pretty test watcher check out [Watcher](https://github.com/BenchR267/Watcher)! 👌🏻

It trades versatility for a much prettier output & fancy spinners. Who doesn't love fancy spinners? 🤩

---

*swift-watch* is directly inspired by Rust's [*cargo-watch*](https://github.com/passcod/cargo-watch). 🙌🏻