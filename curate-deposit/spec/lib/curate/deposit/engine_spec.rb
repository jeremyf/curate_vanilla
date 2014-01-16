require 'spec_helper'

module Curate::Deposit
  describe Engine do
    context '.register_new_form_for' do
      context ':work form' do
        subject { Curate::Deposit.finalize_new_form_for(:work) }
        its(:work_type) { should eq :work }
        its(:finalizer_config) { should be_a_kind_of Hash }
        it { should respond_to(:new) }
      end

      context ':article form' do
        subject { Curate::Deposit.finalize_new_form_for(:article) }
        its(:work_type) { should eq :article }
        its(:finalizer_config) { should be_a_kind_of Hash }
        it { should respond_to(:new) }
      end
    end
  end
end