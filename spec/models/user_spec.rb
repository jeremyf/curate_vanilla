require 'spec_helper'

describe User do

  context '.search' do
    subject { described_class }
    its(:search) { should be_kind_of ActiveRecord::Relation }
  end

  it { should respond_to(:username) }
end