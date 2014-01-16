require 'spec_helper'

module Curate::Deposit::WorksResponder
  describe Base do
    let(:request) { double('Request', get?: get)}
    let(:get) { nil }
    let(:controller) { double('Controller', request: request, formats: [:html]) }
    let(:resource) { double('Resource', work_type: 'article', to_param: "1234")}
    subject { described_class.new(controller, [resource]) }
    let(:error) { RuntimeError.new }
    context '#navigation_behavior' do
      context 'get?' do
        let(:get) { true }
        it 'raises an error' do
          expect {
            subject.navigation_behavior(error)
          }.to raise_error(error)
        end
      end
      context 'get?' do
        let(:get) { false }
        it 'raises an error' do
          subject.should_receive(:redirect_to).with {|path, options| path == "/concern/articles/1234" && options[:flash][:success] }
          subject.navigation_behavior(error)
        end
      end
    end
  end
end
