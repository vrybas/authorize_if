module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(rule, message: nil)
    !!rule || raise(NotAuthorizedError, message)
  end

  def authorize(*args, &block)
    rule = self.respond_to?(rule_method_name) &&
             self.send(rule_method_name, *args)

    authorize_if(rule || false)
  end

  private

  def rule_method_name
    "authorize_#{action_name}?"
  end

  def action_name
    params[:action]
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
