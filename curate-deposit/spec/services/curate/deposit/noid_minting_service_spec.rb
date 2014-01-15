require 'spec_helper'

module Curate::Deposit
  describe NoidMintingService do
    subject { described_class }
    let(:form) { double }
    let(:attributes) { double }
    context '#call' do
      it 'should return a unique value' do
        identifier_one = subject.call(form, attributes)
        identifier_two = subject.call(form, attributes)
        expect(identifier_two).to_not eq(identifier_one)
      end
    end
  end
end
