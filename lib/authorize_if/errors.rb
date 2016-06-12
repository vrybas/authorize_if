require "byebug"

module AuthorizeIf
  class NotAuthorizedError < StandardError
  end

  class MissingAuthorizationRuleError < StandardError
  end
end
