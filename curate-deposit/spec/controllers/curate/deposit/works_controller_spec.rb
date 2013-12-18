require 'spec_helper'

module Curate::Deposit
  describe WorksController do
    context 'new/create' do
      before(:each) do
        Curate::Deposit.should_receive(:authorize!).and_return(true)
      end
      context 'GET #new' do
        it 'should authorize' do
          get :new, work_type: 'work', use_route: :curate_deposit
        end
        it 'should assign a :work' do
          get :new, work_type: 'work', use_route: :curate_deposit
          expect(assigns(:work)).to respond_to :fieldsets
        end
      end

      context 'POST #create' do
        context 'valid attributes' do
          it 'should assign a work and redirect to completion path' do
            post :create, work_type: 'work', work: { title: 'Hello' }, use_route: :curate_deposit
            expect(assigns(:work)).to respond_to :fieldsets
            expect(response).to redirect_to(controller.curate_deposit.work_path(assigns(:work)))
          end
        end

        context 'invalid attributes' do
          it 'should assign a work and render new action' do
            post :create, work_type: 'work', work: { title: ''}, use_route: :curate_deposit
            expect(response).to be_success
            expect(response).to render_template('new')
          end
        end
      end

    end
  end
end
