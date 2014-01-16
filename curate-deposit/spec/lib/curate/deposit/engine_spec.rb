require 'spec_helper'

module Curate::Deposit
  describe Engine do
    shared_examples "a valid Curate::FormClassBuilder" do |work_type|
      let(:helpful_class_name) do
        /\ACurate::FormClassBuilder\(#{work_type}/
      end
      its(:work_type) { should eq work_type }
      its(:inspect) { should match helpful_class_name }
      its(:to_s) { should match helpful_class_name }
      its(:finalizer_config) { should be_a_kind_of Hash }
      it { should respond_to(:new) }
      context 'an instance' do
        let(:context) { double }
        let(:instance) { subject.new(context) }
        it { expect(instance).to respond_to(:valid?)}
        it 'should not raise an error on #valid?' do
          expect{
            instance.valid?
          }.to_not raise_error(NoMethodError)
        end
      end
    end
    context '.register_new_form_for' do

      context ':work form' do
        subject { Curate::Deposit.finalize_new_form_for(:work) }
        it_behaves_like "a valid Curate::FormClassBuilder", :work
      end

      context ':article form' do
        subject { Curate::Deposit.finalize_new_form_for(:article) }
        it_behaves_like "a valid Curate::FormClassBuilder", :article
      end

      context ':document form' do
        subject { Curate::Deposit.finalize_new_form_for(:document) }
        it_behaves_like "a valid Curate::FormClassBuilder", :document
      end
    end
  end
end
