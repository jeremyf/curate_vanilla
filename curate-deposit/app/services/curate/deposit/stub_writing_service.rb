module Curate::Deposit
  module StubWritingService
    module_function
    def call(form, attributes)
      persisted_object = Curate::Deposit.persisted_instance(form)
      persisted_object.attributes = attributes
      persisted_object.save!
    end
  end
end
