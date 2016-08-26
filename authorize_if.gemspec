$:.push File.expand_path("../lib", __FILE__)

require "authorize_if/version"

Gem::Specification.new do |s|
  s.name        = "authorize_if"
  s.version     = AuthorizeIf::VERSION
  s.authors     = ["Vladimir Rybas"]
  s.email       = ["vladimirrybas@gmail.com"]
  s.homepage    = "https://github.com/vrybas/authorize_if"
  s.summary     = "Minimalistic authorization library for Ruby on Rails applications."
  s.description = "Minimalistic authorization library for Ruby on Rails applications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "rspec-rails", "~> 3"
  s.add_development_dependency "byebug"
end
