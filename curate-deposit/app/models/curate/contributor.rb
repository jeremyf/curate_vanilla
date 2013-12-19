module Curate
  class Contributor
    include Virtus.model
    attribute :name
    attribute :_destroy
    attribute :id
  end
end
