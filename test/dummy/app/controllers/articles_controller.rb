class ArticlesController < ApplicationController
  def index
    authorize_if(params[:authorized]) do |config|
      config.error_message = params[:error_message]
    end

    head 200
  end

  def show
    authorize do |config|
      config.error_message = params[:error_message]
    end

    head 200
  end

  private

  def authorize_show?
    params[:authorized]
  end
end
