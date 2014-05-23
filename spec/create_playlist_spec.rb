require 'spec_helper'
require 'pry-debugger'

describe PL::CreatePlaylist do
  before (:each) do
    PL.db.reset_tables
  end

  it "should return a playlist on success" do
    inputs = {username: "user1", name: "playlist1"}
    result = subject.run(inputs)
    expect(result.success?).to eq(true)
    expect(result.playlist).to be_a(PL::Playlist)
    expect(result.playlist.id).to eq(1)
    expect(result.playlist.name).to eq(inputs[:name])
    expect(result.playlist.username).to eq(inputs[:username])
  end

  it "should return error if playlist taken" do
    inputs = {username: "user1", name: "playlist1"}
    subject.run(inputs)
    # run again
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:playlist_taken)
  end
end