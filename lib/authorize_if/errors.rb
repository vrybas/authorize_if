
module AuthorizeIf
  class NotAuthorizedError < StandardError
    def error_message=(msg)
      @message = msg
    end
  end

  class MissingAuthorizationRuleError < StandardError
  end
end
