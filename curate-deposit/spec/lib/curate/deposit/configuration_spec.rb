require 'spec_helper'

module Curate::Deposit
  describe Configuration do
    subject { Curate::Deposit::Configuration.new }
    let(:config) { {} }
    context '#register_new_form_for' do
      it 'should store the #new_form_for' do
        subject.register_new_form_for(:article, config)
        expect(subject.new_form_for(:article)).to eq(config)
      end
    end
    context '#register_persisted_container' do
      let(:container) { double }
      let(:identifier) { '1234' }
      let(:object) { double('Persisted Object') }
      it 'should expose a finder object' do
        subject.register_persisted_container(:article) { container }
        container.should_receive(:find).with(identifier).and_return(object)
        expect(subject.persisted_instance(:article, identifier)).to eq(object)
      end
    end
  end
end
