module Curate
  module FormClassBuilder
    module_function
    # Responsible for creating an finalized Form class that can be used to send
    # to the controller.
    def build(name, config)
      form_class = Class.new do
        include Virtus.model
        include ActiveModel::Validations
        class_attribute :fieldsets, instance_writer: false, instance_reader: false
        class_attribute :work_type, instance_writer: false
        class_attribute :finalizer_config, instance_writer: false
        self.fieldsets = {}

        module_exec(self) do |module_context|
          def self.inspect
            "Curate::FormClassBuilder(#{work_type},#{finalizer_config})"
          end
          def self.to_s
            "Curate::FormClassBuilder(#{work_type},#{finalizer_config})"
          end
        end

        attr_reader :controller
        def initialize(controller, existing_identifier = nil)
          @controller = controller
          super()
          self.minted_identifier = existing_identifier
          on_load_from_persistence if persisted?
        end

        def fieldsets
          @fieldsets ||= self.class.fieldsets.map {|name, attribute_names| ::Curate::FormFieldset.new(self, name, attribute_names)}
        end

        attr_accessor :minted_identifier
        protected :minted_identifier=
        def inspect
          "<FinalizedForm/#{work_type}#{persisted? ? " ID: " << minted_identifier : ' '}\n{\n\tattributes: #{attributes.inspect},\n\n\tfinalizer_config: #{finalizer_config.inspect}\n}\n--->"
        end

        def save
          valid? ? on_save : false
        end

        def on_save
          true
        end

        def on_load_from_persistence
          true
        end

        def to_param
          minted_identifier
        end

        def to_key
          persisted? ? [minted_identifier] : nil
        end

        def persisted?
          minted_identifier.present?
        end

      end
      form_class.finalizer_config = config
      form_class.work_type = name
      form_class
    end
  end
end
