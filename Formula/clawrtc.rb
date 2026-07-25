require "formula"

class Clawrtc < Formula
  desc "Mine RTC tokens - PowerPC G4/G5 get 2.0-2.5x multiplier!"
  homepage "https://bottube.ai"
  url "https://github.com/Scottcjn/Rustchain/archive/refs/tags/clawrtc-v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "44c3ee0a0f0c4b4156f8d37f222101da3693f91eb21b9764a895294bd6ef422d"

  depends_on "python"

  def install
    # Install the universal miner directly for PowerPC.
    # The miner lives under deprecated/old_miners/ in the pinned tag.
    libexec.install "deprecated/old_miners/rustchain_universal_miner.py"

    # Create wrapper script
    (bin/"clawrtc").write <<~EOS
      #!/bin/bash
      exec python #{libexec}/rustchain_universal_miner.py "$@"
    EOS
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

      More info: https://bottube.ai
    EOS
  end

  test do
    system "python", libexec/"rustchain_universal_miner.py", "--help"
  end
end
