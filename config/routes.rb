Rails.application.routes.draw do
  post "sign_up", to: "authorization#sign_up"
  post "generate_token", to: "authorization#generate_token"
  delete "revoke_token", to: "authorization#revoke_token"

  resources :widgets
end
