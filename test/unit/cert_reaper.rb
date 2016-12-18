require 'test_plugin_helper'

class CertReaper < ActiveSupport::TestCase
  setup do
    User.current = User.find('login' => 'admin')
  end

  test 'the truth' do
    assert true
  end
end
