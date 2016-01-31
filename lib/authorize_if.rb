module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)
  MissingAuthorizationRuleError = Class.new(StandardError)

  def authorize_if(rule, &block)
    config = Object.new
    class << config
      attr_accessor :error_message
    end

    block.call(config) if block
    !!rule || raise(NotAuthorizedError, config.error_message)
  end

  def authorize(*args, &block)
    unless self.respond_to?(rule_method_name, true)
      raise(MissingAuthorizationRuleError, missing_rule_error_msg)
    end

    authorize_if(self.send(rule_method_name, *args), &block)
  end

  private

  def rule_method_name
    "authorize_#{action_name}?"
  end

  def missing_rule_error_msg
    [
      "No authorization rule defined for action",
      "#{controller_name}##{action_name}.",
      "Please define method ##{rule_method_name} for",
      self.class.name
    ].join(' ')
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
