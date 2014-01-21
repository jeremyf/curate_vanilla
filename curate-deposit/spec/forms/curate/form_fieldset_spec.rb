require 'spec_helper'

module Curate
  describe FormFieldset do
    let(:form) { double }
    let(:name) { :required }
    let(:attributes) { [{name: :title, type: String, options: {}}] }
    subject { Curate::FormFieldset.new(form, name, attributes)}
    its(:name) { should == name }
    its(:form) { should == form }
    its(:attribute_names) { should == [:title] }

    context '#attributes' do
      subject { Curate::FormFieldset.new(form, name, attributes).attributes }
      it 'should extract the name' do
        expect(subject.first.name).to eq(:title)
      end
    end

    context '#render' do
      subject { Curate::FormFieldset.new(form, name, attributes) }
      let(:template) { double("Template") }
      let(:form_builder) { double("Builder", template: template) }
      before(:each) do
        template.should_receive("fieldset")
      end
      it 'should render each attribute' do
        subject.render(form_builder)
        require 'byebug'; byebug; true;
      end
    end
  end
end
