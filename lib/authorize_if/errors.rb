module AuthorizeIf
  class NotAuthorizedError < StandardError
    def initialize(*)
      @message = nil
      super
    end

    def message=(msg)
      @message = msg
    end
  end

  class MissingAuthorizationRuleError < StandardError
  end
end
