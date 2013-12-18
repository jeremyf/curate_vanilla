$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "curate/deposit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "curate-deposit"
  s.version     = Curate::Deposit::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Curate::Deposit."
  s.description = "TODO: Description of Curate::Deposit."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency 'virtus'

  s.add_development_dependency "sqlite3"
end
