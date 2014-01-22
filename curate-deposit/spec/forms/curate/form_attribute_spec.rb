require 'spec_helper'

module Curate
  describe FormAttribute do
    let(:fieldset) { double(controller: double, form: double, work_type: double) }
    let(:config) { { name: :title, type: String, options: {} } }
    subject { Curate::FormAttribute.new(fieldset, config)}
    its(:name) { should == :title }
    its(:input_options) { should be_a(Hash) }
    its(:work_type) { should eq fieldset.work_type }

    context '#render' do
      let(:template) { double("Template") }
      let(:form_builder) { double("Builder", template: template) }
      it 'should render each attribute' do
        template.should_receive("render").with(subject.partial_path, {f: form_builder, attribute: subject})
        subject.render(form_builder)
      end
    end

  end
end
