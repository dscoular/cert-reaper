require File.expand_path('../lib/foreman_my_plugin/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_my_plugin'
  s.version     = ForemanMyPlugin::VERSION
  s.date        = Time.now
  s.authors     = ['Doug Scoular']
  s.email       = ['dscoular@cisco.com']
  s.homepage    = ''
  s.summary     = 'My first Foreman plugin.'
  # also update locale/gemspec.rb
  s.description = 'My first attempt at a foreman plugin based on the plugin example.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
