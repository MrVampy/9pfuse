# 9pfuse

Standalone build of plan9port's `9pfuse`: a FUSE server that presents a POSIX-facing filesystem to Linux tools while using 9P underneath.

This repo carries the Vault-local 9pfuse bridge patches without requiring a full plan9port rebuild for every mount-client change. It still builds against plan9port for `mk`, `9c`, `9l`, headers, and libraries.

## Source

The original source is `src/cmd/9pfuse` from `github.com/9fans/plan9port`, authored by Russ Cox and distributed under the license preserved in `COPYRIGHT`.

Local changes currently include:

- explicit `-u uname` attach principal selection;
- Linux-safe synthetic inode numbers;
- missing-path errno mapping for FUSE create flows;
- POSIX file-over-file rename bridging for editor temp-file saves;
- large FUSE write negotiation for mounted workspace copies, while 9P writes
  are still split at the negotiated 9P msize by lib9pclient.

## Build

```bash
nix build
```

The resulting binary is at `result/bin/9pfuse`.

For direct development against a full plan9port checkout:

```bash
export PLAN9=/path/to/plan9port
export PATH="$PLAN9/bin:$PATH"
mk
```
