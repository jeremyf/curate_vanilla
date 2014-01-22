module Curate
  # Responsible for rendering its constituent parts
  class FormFieldset
    attr_reader :name, :form
    def initialize(form, name, attribute_configurations)
      @form = form
      @name = name
      @attribute_configurations = attribute_configurations
    end

    delegate :work_type, to: :form

    def attributes
      @attributes ||= attribute_configurations.collect {|ac| ::Curate::FormAttribute.new(self, ac) }
    end

    def attribute_names
      attribute_configurations.collect{|config| config.fetch(:name) }
    end

    def render(f, template = f.template)
      template.render(partial_path, f: f, fieldset: self)
    end

    def partial_path
      "curate/form/#{work_type}/deposit/fieldset_#{name}"
    end

    protected
    attr_reader :attribute_configurations
  end
end
