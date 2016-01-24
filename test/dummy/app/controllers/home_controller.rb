class HomeController < ApplicationController
  def show_authorized
    authorize_if true

    head 200
  end

  def show_unauthorized
    authorize_if false
  end
end
