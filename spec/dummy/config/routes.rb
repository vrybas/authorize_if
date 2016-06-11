Rails.application.routes.draw do
  namespace "articles" do
    get "/index", to: :index
  end
end
