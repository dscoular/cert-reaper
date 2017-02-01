Rails.application.routes.draw do
  get 'clear_cert', to: 'cert_reaper/hosts#clear_cert'
  get 'multiple_clear_cert', to: 'cert_reaper/hosts#multiple_clear_cert'
  post 'submit_multiple_clear_cert',
       to: 'cert_reaper/hosts#submit_multiple_clear_cert'
end
