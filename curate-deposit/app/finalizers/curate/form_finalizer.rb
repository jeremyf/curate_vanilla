module Curate
  # Responsible for translating a form configuration to a form object that can
  # be rendered and persisted
  class FormFinalizer
    def self.call(name, config)
      new(name, config).base_class
    end
    attr_reader :base_class
    def initialize(name, config)
      @name, @config = name, config
      construct_base_class
      append_model_name
      apply_identity_minter(config.fetch(:identity_minter))
      apply_fieldsets
      apply_on_save(config)
    end

    private

    attr_reader :config, :name
    def apply_fieldsets
      config.fetch(:fieldsets, {}).each_pair do |fieldset_name, options|
        attribute_names = []
        apply_attributes(options) {|attribute_name, *| attribute_names << attribute_name }
        apply_validation(options)
        apply_on_save(options)
        base_class.fieldsets[fieldset_name] = attribute_names
      end
    end

    def apply_attributes(options = {})
      options.fetch(:attributes, {}).each_pair do |name, config|
        type, opts = extract_attribute_parameters_from(config)
        base_class.attribute(name, type, opts)
        yield(name, type, opts) if block_given?
      end
    end

    def extract_attribute_parameters_from(config)
      type = config
      options = {}
      if config.is_a?(Array)
        if config.size == 2
          type = config.first
          options = config.last
        end
      end
      [type, options]
    end
    private :extract_attribute_parameters_from


    def apply_on_save(options = {})
      on_save_options = options.fetch(:on_save, {})
      if on_save_options.present?
        base_class.instance_exec(on_save_options) do |opts|
          on_save_method = instance_method(:on_save)
          define_method(:on_save) do
            on_save_method.bind(self).call
            opts.each_pair {|name, callable| callable.call(self, attributes) }
          end
        end
      end
    end

    def apply_identity_minter(minter)
      minter = normalize_to_callable(minter)
      base_class.instance_exec(minter) do |iminter|
        on_save_method = instance_method(:on_save)
        define_method(:on_save) do
          on_save_method.bind(self).call
          self.minted_identifier = iminter.call(self, attributes)
        end
      end
    end

    def apply_validation(options = {})
      options.fetch(:validates, {}).each_pair do |name, *args|
        base_class.validates(name, *args)
      end
    end

    def normalize_to_callable(callable)
      callable.respond_to?(:call) ? callable : callable.to_s.constantize
    end

    def construct_base_class
      @base_class = Class.new do
        include Virtus.model
        include ActiveModel::Validations
        class_attribute :fieldsets
        class_attribute :work_type
        class_attribute :finalizer_config, instance_writer: false
        self.fieldsets = {}

        attr_reader :controller
        def initialize(controller)
          @controller = controller
          super()
        end

        attr_accessor :minted_identifier
        protected :minted_identifier=
        def inspect
          "<FinalizedForm/#{work_type}#{persisted? ? " ID: " << minted_identifier : ' '}{\n\tattributes: #{attributes.inspect},\n\n\tfinalizer_config: #{finalizer_config.inspect}\n}>"
        end

        def save
          valid? ? on_save : false
        end

        def on_save
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
      @base_class.finalizer_config = config
      @base_class.work_type = name
      @base_class
    end

    def append_model_name(model_name = name)
      base_class.class_exec(model_name) do |name|
        define_singleton_method(:model_name) do
          ActiveModel::Name.new(name.to_s.classify, nil, name.to_s.classify)
        end
      end
    end

  end
end
