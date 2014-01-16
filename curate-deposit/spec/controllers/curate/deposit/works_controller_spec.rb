require 'spec_helper'

module Curate::Deposit
  describe WorksController do
    context 'new/create' do
      # @NOTE - There is a lot of knowledge of how the form object is built.
      #
      # Given that we are dynamically looking up what forms to use
      # It is, at present, hard to intercept the returned form object.
      # The goal of these stubs is to not worry about how the forms are created
      # but instead making sure the controller is behaving as expected:
      # * Does it trigger an authorization check
      # * Does it fetch the appropriate form
      # * Does it redirect on a successful save
      # * Does it render the 'new' action on a failed save
      let(:work_type) { 'foo' }
      let(:work_form_class) { Curate::FormFinalizer.call(work_type, work_form_configuration) }
      let(:work_form) { work_form_class.new(controller) }
      let(:pid) { '1234' }
      let(:work_form_configuration) {
        {
          fieldsets: { required: { attributes: { title: String }, validates: { title: {presence: true} } } },
          identity_minter: lambda {|*args| pid }
        }
      }

      before(:each) do
        Curate::Deposit.should_receive(:new_form_for).with(controller, work_type).and_return(work_form)
        Curate::Deposit.should_receive(:authorize!).with(controller, work_form).and_return(true)
      end

      context 'GET #new' do
        it 'should authorize' do
          get :new, work_type: work_type, use_route: :curate_deposit
        end
        it 'should assign a :work' do
          get :new, work_type: work_type, use_route: :curate_deposit
          expect(assigns(:work)).to respond_to :fieldsets
        end
      end

      context 'POST #create' do
        context 'valid attributes' do
          it 'should assign a work and redirect to completion path' do
            post :create, work_type: work_type, work: { title: 'Hello' }, use_route: :curate_deposit
            expect(assigns(:work)).to respond_to :fieldsets
            expect(response).to redirect_to(controller.curate_deposit.work_path(assigns(:work)))
          end
        end

        context 'invalid attributes' do
          it 'should assign a work and render new action' do
            post :create, work_type: work_type, work: { title: ''}, use_route: :curate_deposit
            expect(response).to be_success
            expect(response).to render_template('new')
          end
        end
      end

    end
  end
end
