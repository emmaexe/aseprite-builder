# Aseprite Builder

![GitHub License](https://img.shields.io/github/license/emmaexe/aseprite-builder)

**A build script for aseprite for debian-based systems. Uses the latest release of aseprite from github with the latest release of the prebuilt skia binaries.**
I made the script for myself and decided to clean it up a little and publish it.

![Aseprite Builder Demo](https://raw.githubusercontent.com/emmaexe/aseprite-builder/main/assets/demo.gif)

## Usage

Run this to use the script:

```bash
git clone https://github.com/emmaexe/aseprite-builder && cd aseprite-builder && ./aseprite-build.sh
```

The aseprite-build.sh script contains everything you need. It will install all dependencies and build aseprite within the cloned repository.
The script makes use of [gum](https://github.com/charmbracelet/gum) and will try to use any gum binary installed on the computer. If it can't find one, it will fall back to installing it to a temporary directory for the script to use while it runs.

## Tested on

Tested and works on:

- Ubuntu 24.04 LTS
- Debian 12 Bookworm

Last tested with:

- Aseprite v1.3.7
- Skia m102

## Feedback and support

If you need support or have any feedback, you can open a pull request or issue on the [github page](https://github.com/emmaexe/aseprite-builder/issues), or join the [discord](https://ln.emmaexe.moe/discord-server) or [matrix (WIP)](https://ln.emmaexe.moe/matrix-server) servers.

## Authors

- [@emmaexe](https://www.emmaexe.moe/)
