require 'spec_helper'

describe AdminConstraint do
  context '.is_admin?' do
    subject { AdminConstraint.is_admin?(user) }

    context 'for object responding to username' do
      let(:user) { double(username: username) }

      context 'with username macthing data store' do
        let(:username) { ENV['USER'] }
        it { should be_true }
      end

      context 'with username not macthing data store' do
        let(:username) { "not-#{ENV['USER']}" }
        it { should be_false }
      end
    end

    context 'for object not responding to username' do
      let(:user) { username }

      context 'with to_s macthing data store' do
        let(:username) { ENV['USER'] }
        it { should be_true }
      end

      context 'with to_s not macthing data store' do
        let(:username) { "not-#{ENV['USER']}" }
        it { should be_false }
      end
    end

  end
end
