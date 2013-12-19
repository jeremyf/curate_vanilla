module Curate::Deposit
  module MintingService
    module_function
    def call(form, attributes)
      "#{Sufia.config.id_namespace}:#{rand(100000000000000)}"
    end
  end
end