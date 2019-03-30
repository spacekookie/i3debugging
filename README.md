# Reproducing weird `i3` bugs

There's a peculiar bug that was (probably) introduced in `i3` version `4.16.1`
where selections aren't properly scoped between workspaces.

This set of tools can reliably reproduce the issue and run in a git-bisect.

- `src/main.rs` is a simple web-server which answers on a FIFO if it is hit
- `debug.lua` is a script that invokes some `xdotool` commands
  and listens for a response from the FIFO.
- `bisect.sh` is the actual script to run the git-bisect
- `default.nix` allows you to reproducibly build an environment
  with all of these tools present in your path

## Findings

WIP: will update as new information comes up :)
