Rails.application.routes.draw do
  namespace "articles" do
    get "/index", action: :index
  end
end
