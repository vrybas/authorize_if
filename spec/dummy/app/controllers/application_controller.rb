class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from "AuthorizeIf::NotAuthorizedError" do |exception|
    render plain: exception.message, status: 403
  end

  protected

  def current_user
    raise "stub this method in spec"
  end
end
