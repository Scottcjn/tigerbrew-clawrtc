require "formula"

class Clawrtc < Formula
  desc "Mine RTC tokens - PowerPC G4/G5 get 2.0-2.5x multiplier!"
  homepage "https://bottube.ai"
  # Pinned to the commit that the Rustchain clawrtc-v1.0.0 release tag points at.
  # Do not point this at a branch: a branch tarball changes every time anything
  # lands on that branch, so no sha256 could ever match it and every install
  # would run whatever code happened to be on main at that moment.
  url "https://github.com/Scottcjn/Rustchain/archive/19c1fd029b89de9f5b97da3432d3eb12829f6d95.tar.gz"
  version "1.0.0"
  sha256 "cfbc146749b369ddf7ee269e0c7fe0739492109b44bc9f82721eaf1aae1471ed"

  depends_on "python"

  def install
    # Path is relative to the pinned tarball above. If you move the pin, confirm
    # this file still exists at the new commit before merging.
    libexec.install "deprecated/old_miners/rustchain_universal_miner.py"

    # Create wrapper script
    (bin/"clawrtc").write <<~EOS
      #!/bin/bash
      exec python #{libexec}/rustchain_universal_miner.py "$@"
    EOS
    chmod 0755, bin/"clawrtc"
  end

  def caveats
    <<~EOS
      ClawRTC on PowerPC Mac — you're earning bonus multipliers!

        PowerPC G4: 2.5x reward multiplier
        PowerPC G5: 2.0x reward multiplier

      Quick start:
        clawrtc --wallet my-g4-miner

      Your vintage hardware earns MORE than modern machines.
      Real iron only — VMs get nothing.

      The miner imports the Python "requests" module, so install it first:
        pip install requests

      More info: https://bottube.ai
    EOS
  end

  test do
    system "python", libexec/"rustchain_universal_miner.py", "--help"
  end
end
