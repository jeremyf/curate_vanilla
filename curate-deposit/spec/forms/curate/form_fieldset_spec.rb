require 'spec_helper'

module Curate
  describe FormFieldset do
    let(:form) { double(controller: double) }
    let(:name) { :required }
    let(:attributes) { [] }
    subject { Curate::FormFieldset.new(form, name, attributes)}
    its(:name) { should == name }
    its(:attribute_names) { should == attributes }
    its(:controller) { should == form.controller }
  end
end