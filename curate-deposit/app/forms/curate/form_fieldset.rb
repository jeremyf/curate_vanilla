module Curate
  # Responsible for rendering its constituent parts
  class FormFieldset
    attr_reader :name, :form
    def initialize(form, name, attribute_configurations)
      @form = form
      @name = name
      @attribute_configurations = attribute_configurations
    end

    def attributes
      @attributes ||= attribute_configurations.collect {|ac| ::Curate::FormAttribute.new(self, ac) }
    end

    def attribute_names
      attribute_configurations.collect{|config| config.fetch(:name) }
    end

    protected
    attr_reader :attribute_configurations
  end
end
