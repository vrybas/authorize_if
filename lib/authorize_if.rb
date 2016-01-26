module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(obj)
    authorized_obj = !!obj

    authorized_obj || raise(NotAuthorizedError)
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
