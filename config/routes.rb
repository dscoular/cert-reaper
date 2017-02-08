Rails.application.routes.draw do
  get 'clear_cert', to: 'cert_reaper/hosts#clear_cert'
  get 'multiple_clear_cert', to: 'cert_reaper/hosts#multiple_clear_cert'
  post 'submit_multiple_clear_cert',
       to: 'cert_reaper/hosts#submit_multiple_clear_cert'
  namespace :cert_reaper do
    namespace :api do
      scope '(:apiv)', :module => :v2,
                       :defaults => { :apiv => 'v2' },
                       :apiv => /v1|v2/,
                       :constraints => ApiConstraints.new(:version => 2) do
        # resource :certs, :only => [:destroy]
        delete '/certs/:certname',
               controller: 'certs',
               to: :destroy,
               # The default constraint doesn't allow "." so we have to
               # explicitly set the constraint to a regex for fqdn hostnames.
               constraints: {
                 certname: /([a-zA-Z0-9](?:(?:[a-zA-Z0-9-]*|
                           (?<!-)\.(?![-.]))*[a-zA-Z0-9]+)?)/x
               }
      end
    end
  end
  #
end
