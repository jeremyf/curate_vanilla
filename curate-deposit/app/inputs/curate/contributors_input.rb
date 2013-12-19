require 'simple_form'

# Render Something Like This
#
# <div class="control-group composite optional foo_bar">
#   <span class="control-label">
#     <label for="foo_bar_baz" class="string composite optional input-xlarge">Baz</label>
#     <label for="foo_bar_bong" class="string composite optional input-xlarge">Bong</label>
#   </span>
#   <div class="controls">
#     <fieldset class="composite-input">
#       <input id="foo_bar_baz" class="foo_bar_baz input-xlarge" name="foo[bar][baz]" size="30" type="text" value="baz1" />
#       <input id="foo_bar_bong" class="foo_bar_bong input-xlarge" name="foo[bar][bong]" size="30" type="text" value="bong1" />
#     </fieldset>
#   </div>
# </div>

module Curate
  class ContributorsInput < SimpleForm::Inputs::Base
    def input
      @rendered_first_element = false
      input_html_classes.unshift("string")
      input_html_options[:type] ||= 'text'
      input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
      markup = ""
      markup << javascript_templates
      markup << <<-HTML


      <ul class="listing">
      HTML

      collection.each_with_index do |value, i|
        unless value.to_s.strip.blank?
          markup << field_wrapper_for(value)
        end
      end

      markup << field_wrapper_for('')
      markup << "</ul>"
    end

    def label_html_options
      returning_value = super
      returning_value[:class] ||= []
      returning_value[:class] << 'multi_value'
      returning_value
    end

    def input_class
      'multi_value'
    end

    private

    def field_wrapper_for(value)
      <<-HTML
      <li class="field-wrapper">
      #{build_text_field(value)}
      </li>
      HTML
    end

    def javascript_templates
      <<-HTML
      <script id="entry-template" type="text/x-handlebars-template">
      <li class="field-wrapper input-append">
      <input id="#{object_name}_#{attribute_name}_{{index}}_id" name="#{object_name}[#{attribute_name}][{{index}}][id]" type="hidden" value="" />
      <input class="input-xlarge autocomplete-users" data-url="/people" id="#{object_name}_#{attribute_name}_{{index}}_name" name="#{object_name}[#{attribute_name}][{{index}}][name]" type="text" value="" />
      <span class="field-controls"><button class="btn btn-success add"><i class="icon-white icon-plus"></i><span>Add</span></button></span>
      </li>
      </script>
      <script id="existing-user-template" type="text/x-handlebars-template">
      <li class="field-wrapper input-append">
      <span class="linked-user"><a href="/people/{{value}}" target="_new">{{label}}</a></span>
      <input type="hidden" name="#{object_name}[#{attribute_name}][{{index}}][id]" value="{{value}}">
      <span class="field-controls"><button class="btn btn-danger remove"><i class="icon-white icon-minus"></i><span>Remove</span></button></span>
      </li>
      </script>
      HTML
    end


    def build_text_field(value)
      options = input_html_options.dup

      options[:value] = value
      if @rendered_first_element
        options[:id] = nil
        options[:required] = nil
      else
        options[:id] ||= input_dom_id
      end
      options[:class] ||= []
      options[:class] += [" multi_value #{input_dom_id} multi-text-field"]
      options[:multiple] ||= 'multiple'
      options[:'aria-labelledby'] = label_id
      @rendered_first_element = true
      @builder.text_field(attribute_name, options)
    end


    def label_id
      input_dom_id + '_label'
    end

    def input_dom_id
      input_html_options[:id] || "#{object_name}_#{attribute_name}"
    end

    def collection
      @collection ||= begin
        object.send(attribute_name)
      end
    end

    def multiple?
      true
    end
  end
end
