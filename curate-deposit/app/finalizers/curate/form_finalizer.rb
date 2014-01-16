module Curate
  # Responsible for translating a form configuration to a form object that can
  # be rendered and persisted.
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
      apply_on_load_from_persistence(config)
    end

    private

    attr_reader :config, :name
    def apply_fieldsets
      config.fetch(:fieldsets, {}).each_pair do |fieldset_name, options|
        attributes = []
        apply_attributes(options) {|name, type, opts| attributes << { name: name, type: type, options: opts } }
        apply_validation(options)
        apply_on_save(options)
        apply_on_load_from_persistence(options)
        base_class.fieldsets[fieldset_name] = attributes
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

    def apply_on_load_from_persistence(options = {})
      on_load_from_persistence_options = options.fetch(:on_load_from_persistence, {})
      if on_load_from_persistence_options.present?
        base_class.instance_exec(on_load_from_persistence_options) do |opts|
          on_load_from_persistence_method = instance_method(:on_load_from_persistence)
          define_method(:on_load_from_persistence) do
            on_load_from_persistence_method.bind(self).call
            opts.each_pair {|name, callable| callable.call(self) }
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
      @base_class = Curate::FormClassBuilder.build(name, config)
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
