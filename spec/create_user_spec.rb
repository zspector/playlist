require 'spec_helper'
require 'pry-debugger'

describe PL::CreateUser do
  before (:each) do
    PL.db.reset_tables
  end

  it "should return a user object on success" do
    inputs = {name: "user1", password: "123"}
    result = subject.run(inputs)
    expect(result.success?).to eq(true)
    expect(result.user).to be_a(PL::User)
    expect(result.user.id).to eq(1)
    expect(result.user.name).to eq(inputs[:name])
    expect(result.user.password).to eq(inputs[:password])
  end

  it "should return error if username taken" do
    inputs = {name: "user1", password: "123"}
    subject.run(inputs)
    # run again
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:name_taken)
  end
end