module AuthorizeIf
  NotAuthorizedError = Class.new(StandardError)

  def authorize_if(obj = nil, &block)
    authorized_obj = !!obj

    if block.present?
      authorized_block = !!block.call(self)
    end

    authorized_obj || authorized_block || raise(NotAuthorizedError)
  end
end

ActiveSupport.on_load :action_controller do
  include AuthorizeIf
end
