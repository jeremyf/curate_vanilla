class Curate::FormFieldset
  attr_reader :name, :attribute_names
  def initialize(form, name, attribute_names)
    @form = form
    @name = name
    @attribute_names = attribute_names
  end
  delegate :controller, to: :form
  protected
  attr_reader :form
end
