require 'spec_helper'

module Curate
  describe FormAttribute do
    let(:fieldset) { double(controller: double, form: double) }
    let(:config) { { name: :title, type: String, options: {} } }
    subject { Curate::FormAttribute.new(fieldset, config)}
    its(:name) { should == :title }
    its(:input_options) { should be_a(Hash) }

  end
end
