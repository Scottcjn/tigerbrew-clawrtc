# frozen_string_literal: true

require "minitest/autorun"

module Kernel
  alias original_require require

  def require(path)
    return true if path == "formula"

    original_require(path)
  end
end

class Formula
  class << self
    attr_reader :desc_value, :homepage_value, :url_value, :sha256_value,
                :version_value, :license_value, :dependencies, :test_block

    def desc(value)
      @desc_value = value
    end

    def homepage(value)
      @homepage_value = value
    end

    def url(value)
      @url_value = value
    end

    def version(value)
      @version_value = value
    end

    def sha256(value)
      @sha256_value = value
    end

    def license(value)
      @license_value = value
    end

    def depends_on(value)
      @dependencies ||= []
      @dependencies << value
    end

    def test(&block)
      @test_block = block
    end
  end

  attr_reader :system_calls

  def system(*args)
    @system_calls ||= []
    @system_calls << args
  end

  def prefix
    "/tmp/tigerbrew-prefix"
  end
end

load File.expand_path("../Formula/beacon.rb", __dir__)
load File.expand_path("../Formula/grazer.rb", __dir__)
load File.expand_path("../Formula/clawrtc.rb", __dir__)

ALL_FORMULAE = [Beacon, Grazer, Clawrtc].freeze

# These guard the whole tap against the class of bug that shipped in clawrtc.rb:
# a formula whose source is not pinned and whose integrity is not checked. Every
# formula in Formula/ must be listed in ALL_FORMULAE above.
class FormulaPinningTest < Minitest::Test
  def test_every_formula_declares_a_real_sha256
    ALL_FORMULAE.each do |formula|
      assert_match(/\A[0-9a-f]{64}\z/, formula.sha256_value.to_s,
                   "#{formula} must declare a 64-char hex sha256. An empty or " \
                   "malformed checksum means brew installs the download unverified.")
    end
  end

  def test_no_formula_downloads_a_mutable_branch
    ALL_FORMULAE.each do |formula|
      refute_match(%r{/archive/refs/heads/}, formula.url_value.to_s,
                   "#{formula} points at a branch tarball. Branch tarballs change " \
                   "whenever anything lands on the branch, so anyone who can land a " \
                   "commit upstream decides what this tap runs on users' machines. " \
                   "Pin a tag or a commit SHA instead.")
      refute_match(/\A.*\bmain\.tar\.gz\z/, formula.url_value.to_s,
                   "#{formula} looks like it downloads a branch tarball. Pin a tag " \
                   "or a commit SHA instead.")
    end
  end
end

class BeaconGrazerFormulaTest < Minitest::Test
  def test_beacon_formula_metadata
    assert_equal "Beacon - agent-to-agent pings with RTC payments (BoTTube, Moltbook, RustChain, UDP)", Beacon.desc_value
    assert_equal "https://bottube.ai/skills/beacon", Beacon.homepage_value
    assert_equal "https://files.pythonhosted.org/packages/source/b/beacon-skill/beacon_skill-0.1.1.tar.gz", Beacon.url_value
    assert_equal "5e65528ea80bb08f46fc562eba984a1a98fcbc788422e35c3769e5921cd56dcb", Beacon.sha256_value
    assert_equal "0.1.1", Beacon.version_value
    assert_equal "MIT", Beacon.license_value
    assert_equal ["python"], Beacon.dependencies
  end

  def test_beacon_install_and_test_commands
    formula = Beacon.new
    formula.install
    formula.instance_eval(&Beacon.test_block)

    assert_equal [
      ["python", "setup.py", "install", "--prefix=/tmp/tigerbrew-prefix"],
      ["python", "-c", "import beacon_skill"]
    ], formula.system_calls
  end

  def test_beacon_caveats_include_quick_start_commands
    caveats = Beacon.new.caveats

    assert_includes caveats, "Beacon installed"
    assert_includes caveats, "beacon init"
    assert_includes caveats, "beacon udp listen --port 38400"
    assert_includes caveats, "https://github.com/Scottcjn/beacon-skill"
  end

  def test_grazer_formula_metadata
    assert_includes Grazer.desc_value, "Multi-Platform Content Discovery"
    assert_equal "https://bottube.ai/skills/grazer", Grazer.homepage_value
    assert_equal "https://files.pythonhosted.org/packages/source/g/grazer-skill/grazer_skill-1.3.0.tar.gz", Grazer.url_value
    assert_equal "7e43e95f42e4b0f03a7f4deb78c8cd57068244a791c41f3fcc84e37c800cde35", Grazer.sha256_value
    assert_equal "1.3.0", Grazer.version_value
    assert_equal "MIT", Grazer.license_value
    assert_equal ["python"], Grazer.dependencies
  end

  def test_grazer_install_and_test_commands
    formula = Grazer.new
    formula.install
    formula.instance_eval(&Grazer.test_block)

    assert_equal [
      ["python", "setup.py", "install", "--prefix=/tmp/tigerbrew-prefix"],
      ["python", "-c", "import grazer_skill"]
    ], formula.system_calls
  end

  def test_grazer_caveats_include_supported_platforms
    caveats = Grazer.new.caveats

    assert_includes caveats, "Grazer installed"
    assert_includes caveats, "grazer discover -p bottube --category music"
    assert_includes caveats, "Works great on PowerPC Tiger/Leopard"
    assert_includes caveats, "https://bottube.ai/skills/grazer"
  end
end

class ClawrtcFormulaTest < Minitest::Test
  PINNED_COMMIT = "19c1fd029b89de9f5b97da3432d3eb12829f6d95"

  def test_clawrtc_source_is_pinned_to_an_immutable_commit
    assert_equal "https://github.com/Scottcjn/Rustchain/archive/#{PINNED_COMMIT}.tar.gz",
                 Clawrtc.url_value
    assert_equal "cfbc146749b369ddf7ee269e0c7fe0739492109b44bc9f82721eaf1aae1471ed",
                 Clawrtc.sha256_value
    assert_equal "1.0.0", Clawrtc.version_value
    assert_equal ["python"], Clawrtc.dependencies
  end

  def test_clawrtc_caveats_explain_the_vintage_multipliers
    caveats = Clawrtc.new.caveats

    assert_includes caveats, "PowerPC G4: 2.5x reward multiplier"
    assert_includes caveats, "PowerPC G5: 2.0x reward multiplier"
    assert_includes caveats, "pip install requests"
  end
end
