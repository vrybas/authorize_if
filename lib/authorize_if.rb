module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(rule)
    !!rule || raise(NotAuthorizedError)
  end

  def authorize
    rule = if self.respond_to?(rule_method_name)
             self.send(:rule_method_name)
           else
             false
           end

    authorize_if(rule)
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
