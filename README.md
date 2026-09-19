# homebrew-dbv-typst-editor

Homebrew tap for [DBV Typst Editor](https://github.com/davidbuenov/dbv-typst-editor) — a native, fast Typst editor with live preview for Windows, macOS and Linux, built with Rust + Tauri v2.

This repository contains only the Homebrew Cask definition. The application source code, releases and the macOS `.dmg` / Linux `.AppImage` builds live in [davidbuenov/dbv-typst-editor](https://github.com/davidbuenov/dbv-typst-editor).

## Install

```sh
brew tap davidbuenov/dbv-typst-editor
brew install --cask dbv-typst-editor
```

- **macOS** (Intel and Apple Silicon): installs `DBV Typst Editor.app` in `/Applications`. The app is not yet signed or notarised by Apple, so Gatekeeper asks for confirmation the first time (right-click → Open).
- **Linux** (x86_64): links the `.AppImage` into Homebrew's AppImage directory. Requires Homebrew 6.0.0 or later, which added AppImage casks, and FUSE 2 to run AppImages (`libfuse2` on Debian/Ubuntu).

## Update

The Cask is updated automatically by CI in the main repository whenever a new Release is published.

```sh
brew upgrade --cask dbv-typst-editor
```

## Uninstall

```sh
brew uninstall --cask dbv-typst-editor
# also remove settings and caches:
brew uninstall --zap --cask dbv-typst-editor
```
