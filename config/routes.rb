Rails.application.routes.draw do
  get 'new_action', to: 'cert_reaper/hosts#new_action'
  get 'clear_cert', to: 'cert_reaper/hosts#clear_cert'
end
