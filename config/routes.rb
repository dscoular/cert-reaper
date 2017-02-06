Rails.application.routes.draw do
  get 'clear_cert', to: 'cert_reaper/hosts#clear_cert'
  get 'multiple_clear_cert', to: 'cert_reaper/hosts#multiple_clear_cert'
  post 'submit_multiple_clear_cert',
       to: 'cert_reaper/hosts#submit_multiple_clear_cert'

  namespace :cert_reaper do
    namespace :api do
      scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'},
          :apiv => /v1|v2/, :constraints => ApiConstraints.new(:version => 2) do

        resource :certs, :only => [:destroy]
      end
    end
  end
end
