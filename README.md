# swift-watch

Watches over your Swift project's source.

# Installation

1. Build
2. Install in `$PATH` (such as in `/usr/local/bin/`)

# Usage

1. Run `$ cd /path/to/swift/package/`
2. Run `$ swift watch -x="build"`
3. Modify some files in `$ cd /path/to/swift/package/`
4. Watch swift-watch do its thing

# Options

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

*swift-watch* was directly inspired by Rust's [*cargo-watch*](https://github.com/passcod/cargo-watch). 🙌🏻
