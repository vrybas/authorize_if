module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(rule)
    !!rule || raise(NotAuthorizedError)
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
