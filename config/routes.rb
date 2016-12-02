Rails.application.routes.draw do
  get 'new_action', to: 'foreman_my_plugin/hosts#new_action'
  get 'clear_cert', to: 'foreman_my_plugin/hosts#clear_cert'
end
