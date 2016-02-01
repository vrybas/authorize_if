# Provides a set of methods to handle authorization scenarios.
# It is included to ActionController::Base on load.
#
module AuthorizeIf
  NotAuthorizedError            = Class.new(StandardError)
  MissingAuthorizationRuleError = Class.new(StandardError)

  Configuration = Class.new do
    attr_accessor :error_message
  end

  # Evaluates given object as boolean. Returns 'true' if object
  # evaluates to 'true'. Raises `AuthorizeIf::NotAuthorizedError`
  # if object evaluates to 'false'.
  #
  # Also accepts block and calls it with `AuthorizeIf::Configuration`
  # object as parameter. Behavior can be customized by calling methods
  # on configuraiton object.
  #
  # @param [Object] rule
  #   The authorization rule. Any "truthy" or "falsey" Ruby object.
  #
  # @param [Proc] block
  #   The configuration block. Supported configuration:
  #     `error_message=()` - custom error message, which will be raised
  #                          along with `AuthorizeIf::NotAuthorizedError`
  #                          exception.
  #
  # @example
  #     class ArticlesController
  #       def index
  #         authorize_if current_user
  #         # => true
  #
  #         ...
  #       end
  #
  #       def edit
  #         @article = Article.find(params[:id])
  #
  #         authorize_if @article.authors.include?(current_user) do |config|
  #           config.error_message = "You are not authorized!"
  #         end
  #         # => AuthorizeIf::NotAuthorizedError: You are not authorized!
  #
  #         ...
  #       end
  #     end
  #
  #
  # @return [Boolean]
  #   Returns 'true' if given object evaluates to 'true'.
  #
  # @raise [AuthorizeIf::NotAuthorizedError]
  #   Raised if given object evaluates to 'false'.
  #
  def authorize_if(rule, &block)
    config = Configuration.new
    block.call(config) if block

    !!rule || raise(NotAuthorizedError, config.error_message)
  end

  # Accepts any arguments and configuration block. Calls corresponding
  # authorization rule method with given arguments, except block.
  #
  # Then calls `#authorize_if` with the returning value of corresponding
  # authorization rule as first argument, and with given configuration block.
  #
  # @param *args
  #   Any arguments, which will be given to corresponding
  #   authorization rule.
  #
  # @param [Proc] block
  #   The configuration block. See `#authorize_if` for complete list of
  #   configuration options.
  #
  # @example
  #     class ArticlesController
  #       def index
  #         authorize
  #         # => true
  #
  #         ...
  #       end
  #
  #       def edit
  #         @article = Article.find(params[:id])
  #
  #         authorize(@article) do |config|
  #           config.error_message = "You are not authorized!"
  #         end
  #         # => AuthorizeIf::NotAuthorizedError: You are not authorized!
  #
  #         ...
  #       end
  #
  #       def destroy
  #         authorize
  #         # => AuthorizeIf::MissingAuthorizationRuleError: No authorization
  #           rule defined for action articles#destroy. Please define
  #           method #authorize_destroy? for ArticlesController
  #
  #         ...
  #       end
  #
  #       private
  #
  #       def authorize_index?
  #         current_user.present?
  #       end
  #
  #       def authorize_edit?(article)
  #         article.author == current_user
  #       end
  #     end
  #
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
