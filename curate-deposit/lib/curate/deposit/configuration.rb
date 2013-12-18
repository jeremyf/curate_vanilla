module Curate::Deposit
  class Configuration < Rails::Engine::Configuration

    def initialize(*args)
      super
      @new_forms = {}
      @persistence_containers = {}
    end

    def register_new_form_for(work_type, config)
      @new_forms[work_type.to_sym] = config
    end

    def new_form_for(work_type)
      @new_forms.fetch(work_type.to_sym)
    end

    def register_persisted_container(work_type, &proc)
      @persistence_containers[work_type.to_sym] = proc
    end

    def persisted_instance(work_type, identifier)
      fetch_persistence_container_for(work_type).find(identifier)
    end

    private
    def fetch_persistence_container_for(work_type)
      @persistence_containers.fetch(work_type.to_sym).call
    end
  end
end
