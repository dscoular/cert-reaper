require File.expand_path('../lib/cert_reaper/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'cert_reaper'
  s.version     = CertReaper::VERSION
  s.date        = Time.now.getlocal
  s.authors     = ['Doug Scoular']
  s.email       = ['dscoular@cisco.com']
  s.homepage    = ''
  s.summary     = 'Foreman plugin to allow removal of host puppet certificates.'
  # also update locale/gemspec.rb
  s.description = 'My first attempt at a foreman plugin based on the plugin example.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
