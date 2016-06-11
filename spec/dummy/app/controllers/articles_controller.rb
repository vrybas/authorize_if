class ArticlesController < ApplicationController
  def index
    authorize_if(current_user.present?) do |config|
      config.error_message = params[:error_message]
    end

    head 200
  end
end
