Pinger::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  get "/cron", to: "home#cron"

  root to: "home#index"

end
