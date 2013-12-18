require 'spec_helper'
module Curate
  describe FormFinalizer do
    let(:name) { 'Article' }
    let(:config) do
      {
        fieldsets: {
          required:
          { attributes: { title: String },
            validates: { title: {presence: true} },
            on_save: { publish_title: title_publisher },
            },
          secondary:
          { attributes: { abstract: String }}
        },
        on_save: { schedule: scheduler },
        identity_minter: minter
      }
    end
    let(:title_publisher) { double }
    let(:minter) { lambda {|obj, att| minted_identifier } }
    let(:minted_identifier) { 'abc123' }
    let(:scheduler) { double }
    let(:base_class) { described_class.call(name, config) }

    context 'instance of base_class' do
      subject { base_class.new }
      it { should respond_to :title }
      it { should respond_to :title= }
      it { should respond_to :abstract }
      it { should respond_to :abstract= }
      its(:fieldsets) { should eq( {required: [:title], secondary: [:abstract] } ) }

      context '#save' do
        context 'when #valid?' do
          let(:valid_attributes) { { title: 'Title' } }
          it 'should call each save plugin' do
            subject.attributes = valid_attributes
            minter.should_receive(:call).with(subject, subject.attributes).ordered.and_return(minted_identifier)
            title_publisher.should_receive(:call).with(subject, subject.attributes).ordered
            scheduler.should_receive(:call).with(subject, subject.attributes).ordered

            expect {
              subject.save
            }.to change(subject, :minted_identifier).from(nil).to(minted_identifier)
          end
        end
      end

      context '#inspect' do
        it 'should be more verbose than you would ever want' do
          expect(subject.inspect).to match(/attributes: {/)
          expect(subject.inspect).to match(/finalizer_config: {/)
        end
      end
    end

    context 'base_class' do
      subject { base_class }
      its(:model_name) { should be_a ActiveModel::Name }
      it 'should use the input name as model_name' do
        expect(subject.model_name.to_str).to eq name
      end
      its(:finalizer_config) { should eq(config) }
    end
  end
end
