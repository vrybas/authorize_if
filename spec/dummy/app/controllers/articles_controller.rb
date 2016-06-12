class ArticlesController < ApplicationController
  def index
    authorize_if(current_user.present?) do |exception|
      exception.error_message = params[:error_message]
    end

    head 200
  end
end
