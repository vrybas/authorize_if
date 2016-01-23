$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authorize_if/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authorize_if"
  s.version     = AuthorizeIf::VERSION
  s.authors     = ["Vladimir Rybas"]
  s.email       = ["vladimirrybas@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AuthorizeIf."
  s.description = "TODO: Description of AuthorizeIf."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
