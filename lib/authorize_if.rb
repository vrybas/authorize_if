module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(rule, &block)
    config = Object.new
    class << config
      attr_accessor :error_message
    end

    block.call(config) if block
    !!rule || raise(NotAuthorizedError, config.error_message)
  end

  def authorize(*args, &block)
    rule = self.respond_to?(rule_method_name) &&
             self.send(rule_method_name, *args)

    authorize_if((rule || false), &block)
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
