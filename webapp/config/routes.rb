Rails.application.routes.draw do
  get 'draper', as: :haml_with_draper,
    controller: :draper, action: :index

  root 'root#index'
end
