# Contributing

Thanks for contributing to the Tigerbrew formulas for Elyan Labs tools. This tap
targets older PowerPC Mac workflows as well as Python-based agent tools, so
formula changes should be conservative and easy to test.

## Getting Started

1. Review the formulas in `Formula/`:
   - `clawrtc.rb` for the RustChain miner.
   - `beacon.rb` for agent-to-agent pings.
   - `grazer.rb` for content discovery.
2. Work on a focused branch:

   ```bash
   git checkout -b your-change-name
   ```

## Development Workflow

Keep changes scoped to one formula or one shared tap concern. Avoid combining
version bumps, checksum changes, caveat rewrites, and test changes in one PR
unless they are required for the same release.

## Formula Guidelines

- Keep `url`, `version`, `sha256`, and `license` fields accurate.
- Use formula tests that work without network credentials.
- Keep caveats short and copy-pasteable for users on older macOS systems.
- Do not remove PowerPC-specific notes unless the formula no longer supports
  that path.
- Prefer explicit Python import or CLI help checks in `test do` blocks.

## Validation

For formula changes, include:

```bash
brew audit --strict --online Formula/<name>.rb
brew install --build-from-source Formula/<name>.rb
brew test Formula/<name>.rb
```

If full Homebrew validation is not available, state that clearly and include
Ruby syntax checks or manual formula review.

## Pull Request Checklist

Before opening a PR, include:

- Formula changed and why.
- Version/checksum source, if changed.
- Commands run and outputs.
- macOS/Tigerbrew/Homebrew environment used.
- Known limitations for PowerPC or modern macOS users.

