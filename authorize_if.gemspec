$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authorize_if/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authorize_if"
  s.version     = AuthorizeIf::VERSION
  s.authors     = ["Vladimir Rybas"]
  s.email       = ["vladimirrybas@gmail.com"]
  s.homepage    = "https://github.com/vrybas/authorize_if"
  s.summary     = "Minimalistic authorization library for Ruby on Rails applications."
  s.description = "Minimalistic authorization library for Ruby on Rails applications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "m", "~> 1.3.1"
  s.add_development_dependency "byebug"
end
