$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'report_cat/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'report_cat'
  s.version     = ReportCat::VERSION
  s.authors     = ['Rich Humphrey']
  s.email       = ['rich@schrodingersbox.com']
  s.homepage    = 'https://github.com/schrodingersbox/report_cat'
  s.summary     = 'A Rails engine to generate simple web-based reports with charts'
  s.description = ''

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~>2.14.0'
  s.add_development_dependency 'rspec-rails', '~>2.14.0'
  s.add_development_dependency 'webrat', '~>0.7.3'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'

  s.add_development_dependency 'autotest'
  s.add_development_dependency 'autotest-fsevent'
  s.add_development_dependency 'autotest-growl'
  s.add_development_dependency 'autotest-rails'
  s.add_development_dependency 'autotest-standalone'
end
