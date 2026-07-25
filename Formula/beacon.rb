require "formula"

class Beacon < Formula
  desc "Beacon - agent-to-agent pings with RTC payments (BoTTube, Moltbook, RustChain, UDP)"
  homepage "https://bottube.ai/skills/beacon"
  url "https://files.pythonhosted.org/packages/source/b/beacon-skill/beacon_skill-0.1.1.tar.gz"
  sha256 "5e65528ea80bb08f46fc562eba984a1a98fcbc788422e35c3769e5921cd56dcb"
  version "0.1.1"
  license "MIT"

  depends_on "python"

  def install
    # The 0.1.1 sdist ships no setup.py (pyproject/setup.cfg only); give
    # old setuptools a shim so setup.py install still works.
    unless File.exist?("setup.py")
      File.write("setup.py", "from setuptools import setup\nsetup()\n")
    end
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
