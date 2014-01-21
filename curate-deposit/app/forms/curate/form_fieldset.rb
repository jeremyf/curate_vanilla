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

    def render(f, template = f.template)
      template.content_tag("fieldset") do
        text = template.content_tag("legend", name) + "\n"
        attributes.each_with_object(text) do |attribute, html|
          html << "\n" << template.render("curate/form/attribute/#{form.work_type}/deposit/#{attribute.name}", f: f, attribute: attribute)
        end
      end
    end

    protected
    attr_reader :attribute_configurations
  end
end
