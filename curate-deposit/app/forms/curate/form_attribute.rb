class Curate::FormAttribute
  attr_reader :fieldset, :attribute
  def initialize(fieldset, attribute)
    @fieldset = fieldset
    @attribute = attribute
  end
end