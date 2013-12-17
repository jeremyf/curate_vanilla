require 'spec_helper'

describe Admin::AccountsController do
  let(:user1) { stub_model(User) }
  let(:user2) { stub_model(User) }
  let(:search_results) { double(page: expected_array)}
  let(:expected_array) { [user1, user2]}
  context '#index' do
    before(:each) do
      User.should_receive(:search).with('user').and_return(search_results)
    end
    it 'should get a paginated list of users' do
      get :index, q: 'user'
      expect(response.status).to eq(200)
      expect(assigns(:users)).to eq(expected_array)
    end
  end

  context '#toggle_approval' do
    let(:user_id) { '1234' }
    before(:each) do
      User.should_receive(:find).with(user_id).and_return(user1)
    end
    it 'should toggle' do
      request.env["HTTP_REFERER"] = 'hello.com'
      user1.should_receive(:toggle!)
      post :toggle_approval, id: user_id
      expect(response.status).to eq(302)
      expect(response).to redirect_to(request.env["HTTP_REFERER"] )
    end
  end
end