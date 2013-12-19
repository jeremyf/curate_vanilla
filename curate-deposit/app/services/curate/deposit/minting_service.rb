module Curate::Deposit
  module MintingService
    module_function
    def call(form, attributes)
      "sufia:#{rand(100000000000000)}"
    end
  end
end