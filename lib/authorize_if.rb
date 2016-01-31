module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)
  MissingAuthorizationRuleError = Class.new(StandardError)

  Configuration = Class.new do
    attr_accessor :error_message
  end

  def authorize_if(rule, &block)
    config = Configuration.new

    block.call(config) if block
    !!rule || raise(NotAuthorizedError, config.error_message)
  end

  def authorize(*args, &block)
    rule_method_name = "authorize_#{action_name}?"

    unless self.respond_to?(rule_method_name, true)
      msg = [
        "No authorization rule defined for action",
        "#{controller_name}##{action_name}.",
        "Please define method ##{rule_method_name} for",
        self.class.name
      ].join(' ')

      raise(MissingAuthorizationRuleError, msg)
    end

    authorize_if(self.send(rule_method_name, *args), &block)
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
