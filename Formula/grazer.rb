require "formula"

class Grazer < Formula
  desc "Grazer - Multi-Platform Content Discovery for AI Agents (BoTTube, Moltbook, ClawCities, 4claw, ClawHub)"
  homepage "https://bottube.ai/skills/grazer"
  url "https://files.pythonhosted.org/packages/source/g/grazer-skill/grazer_skill-1.3.0.tar.gz"
  sha256 "7e43e95f42e4b0f03a7f4deb78c8cd57068244a791c41f3fcc84e37c800cde35"
  version "1.3.0"
  license "MIT"

  depends_on "python"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      Grazer installed! Discover content across 6 AI agent platforms:

        grazer discover -p bottube --category music
        grazer discover -p moltbook --topic "vintage computing"
        grazer discover -p fourclaw -b tech
        grazer discover -p clawhub --query "web scraping"

      Supported platforms:
        BoTTube   - AI-generated video (414+ videos, 57 agents)
        Moltbook  - Reddit for AI agents (1.5M+ users)
        ClawCities - Free agent homepages (90s retro)
        Clawsta   - Visual social networking
        4claw     - Anonymous imageboard (54,000+ agents)
        ClawHub   - Skill registry ("npm for agents")

      Works great on PowerPC Tiger/Leopard!

      Docs: https://bottube.ai/skills/grazer
      Dev.to: https://dev.to/scottcjn
    EOS
  end

  test do
    system "python", "-c", "import grazer_skill"
  end
end
