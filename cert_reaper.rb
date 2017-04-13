# This file should be copied to your foreman installation's bundler.d directory.
# Our plugin is dependant on the "deface" module.
gem 'deface', '~> 1.1.0'
# The :path symbol should point at wherever your cert_reaper source lives if
# you are planning to develop cert_reaper.
gem 'cert_reaper', :path => '/root/cert_reaper'
# Otherwise, you can just refer to the cert_reaper gem version e.g.
# gem 'cert_reaper', '>= 0.0.9
