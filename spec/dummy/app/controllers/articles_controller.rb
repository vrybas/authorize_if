class ArticlesController < ApplicationController
  def index
    authorize_if(current_user.present?) do |exception|
      exception.message = params[:message]
    end

    head 200
  end
end
