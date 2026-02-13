require "formula"

class Beacon < Formula
  desc "Beacon - agent-to-agent pings with RTC payments (BoTTube, Moltbook, RustChain, UDP)"
  homepage "https://bottube.ai/skills/beacon"
  url "https://files.pythonhosted.org/packages/source/b/beacon-skill/beacon_skill-0.1.1.tar.gz"
  sha256 ""
  version "0.1.1"
  license "MIT"

  depends_on "python"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      Beacon installed! Agent-to-agent pings across 4 transports:

        beacon init                              # Create config
        beacon bottube ping-agent sophia --like   # Like agent's video
        beacon moltbook upvote 12345             # Upvote a post
        beacon rustchain pay RTCabc... 1.5       # Send RTC payment
        beacon udp listen --port 38400           # Listen for LAN beacons

      Works great with Grazer (discovery) + Beacon (action)!

      Docs: https://github.com/Scottcjn/beacon-skill
      Dev.to: https://dev.to/scottcjn
    EOS
  end

  test do
    system "python", "-c", "import beacon_skill"
  end
end
