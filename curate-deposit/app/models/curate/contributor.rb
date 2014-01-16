module Curate
  class Contributor
    include Virtus.model
    attribute :name
    attribute :_destroy
    attribute :id

    def initialize(attributes = nil)
      self.class.attribute_set.set(self, attributes) if attributes.present?
      set_default_attributes
    end
  end
end
