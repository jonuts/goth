lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'goth/version'

Gem::Specification.new do |s|
  s.name         = "goth"
  s.version      = Goth::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["jonah honeyman"]
  s.email        = ["jonah@honeyman.org"]
  s.summary      = "Google OAuth helpers"
  s.description  = "Helpers to make dealing with google oauth a tad nicer"
  s.files        = Dir.glob("lib/**/*")
  s.require_path = "lib"
  s.homepage     = "https://www.github.com/jonuts/goth"

  s.add_dependency("oauth", "~> 0.4.4")
end

