require 'spec_helper'

module Curate
  describe FormFieldset do
    let(:form) { double(controller: double) }
    let(:name) { :required }
    let(:attributes) { [{name: :title, type: String, options: {}}] }
    subject { Curate::FormFieldset.new(form, name, attributes)}
    its(:name) { should == name }
    its(:form) { should == form }
    its(:attribute_names) { should == [:title] }
    its(:controller) { should == form.controller }

    context '#attributes' do
      subject { Curate::FormFieldset.new(form, name, attributes).attributes }
      it 'should extract the name' do
        expect(subject.first.name).to eq(:title)
      end

    end
  end
end
