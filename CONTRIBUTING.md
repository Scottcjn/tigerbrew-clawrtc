# Contributing to Tigerbrew ClawRTC

Thank you for contributing to Tigerbrew ClawRTC, a Homebrew tap for ClawRTC packages on macOS PowerPC/Intel.

## Project Overview

This repository contains Homebrew formula files for installing ClawRTC and related Elyan Labs tools on macOS using the Tigerbrew package manager (PowerPC-aware fork of Homebrew).

## Formula Structure

```
Formula/
├── clawrtc.rb     # Main ClawRTC CLI tool
├── beacon.rb      # Beacon network tool
└── grazer.rb      # Grazer agent tool
```

## Testing Formula Changes

```bash
# Install from local formula
brew install --formula ./Formula/clawrtc.rb

# Audit a formula
brew audit --formula ./Formula/clawrtc.rb

# Style check
brew style --formula ./Formula/clawrtc.rb

# Test install
brew install --dry-run ./Formula/clawrtc.rb
```

## Submitting Changes

1. Fork the repository
2. Edit the formula file in `Formula/`
3. Test with `brew audit` and `brew style`
4. Ensure the URL and sha256 are correct
5. Submit a pull request

## Ideas for Contributions

- Add new Elyan Labs tools to the tap
- Update formulas for new versions
- Add ARM64 (Apple Silicon) support where applicable
- Improve bottle definitions for faster installation
