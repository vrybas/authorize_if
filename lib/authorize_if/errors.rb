module AuthorizeIf
  class NotAuthorizedError < StandardError
    attr_reader :context

    def initialize(*)
      @message = nil
      @context = {}

      super
    end

    def message=(msg)
      @message = msg
    end
  end

  class MissingAuthorizationRuleError < StandardError
  end
end
