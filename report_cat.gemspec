$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'system_cat/version'
require 'date'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'report_cat'
  s.version     = SystemCat::Version.new.to_s
  s.date        = Date.today.to_s
  s.authors     = ['Rich Humphrey']
  s.email       = ['rich@schrodingersbox.com']
  s.homepage    = 'https://github.com/schrodingersbox/report_cat'
  s.summary     = 'A Rails engine to generate simple web-based reports with charts'
  s.description = ''

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 6.0', '>= 6.0.0'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'spec_cat'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webrat'
end
