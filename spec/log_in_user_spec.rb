require 'spec_helper'
require 'pry-debugger'

describe PL::LogInUser do
  before (:each) do
    PL.db.reset_tables
  end

  it "should return a user object on success" do
    inputs = {name: "user1", password: "123"}
    user = PL.db.create_user(inputs)
    # PL::CreateUser.run(inputs)
    # binding.pry
    result = subject.run(inputs)
    expect(result.success?).to eq(true)
    expect(result.user).to be_a(PL::User)
    expect(result.user.id).to eq(1)
    expect(result.user.name).to eq(inputs[:name])
    expect(result.user.password).to eq(inputs[:password])
  end

  it "should return error if username does not exist" do
    inputs = {name: "user1", password: "123"}
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_name_does_not_exist)
  end

  it "should return error if username/pass doesn't match" do
    input1 = {name: "user1", password: "123"}
    PL::CreateUser.run(input1)
    input2 = {name: "user1", password: "321"}
    result = subject.run(input2)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_user_or_password)
  end
end