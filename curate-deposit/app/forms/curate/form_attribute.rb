module Curate

  # Responsible for assisting with rendering of the attribute
  class FormAttribute
    attr_reader :fieldset, :name
    def initialize(fieldset, attribute_configuration)
      @fieldset = fieldset
      @name = attribute_configuration.fetch(:name)
      @type = attribute_configuration.fetch(:type)
      @options = attribute_configuration.fetch(:options)
    end
    delegate :form, to: :fieldset
    attr_reader :attribute_configuration, :type
    protected :attribute_configuration, :type

    def input_options(options = nil)
      options ||= {}
      if type.is_a?(Array)
        if type.first.name == 'File'
          options[:as] = :file
        end
        options[:input_html] ||= {}
        options[:input_html][:multiple] ||= 'multiple'
        options[:as] ||= :multi_value
      elsif type.name == 'Curate::Deposit::Engine::ContributorAttributes'
        options[:as] ||= 'curate/contributors'
        options[:elements] ||= form.attributes.fetch(:contributors_attributes)
      else
        if type.name == 'File'
          options[:as] ||= :file
        end
      end
      options
    end

  end
end
