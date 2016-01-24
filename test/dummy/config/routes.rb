Rails.application.routes.draw do
  get "/show_authorized",   to: "home#show_authorized",   as: :show_authorized
  get "/show_unauthorized", to: "home#show_unauthorized", as: :show_unauthorized
end
