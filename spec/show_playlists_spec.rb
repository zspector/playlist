require 'spec_helper'
require 'pry-debugger'

describe PL::ShowPlaylists do
  before (:each) do
    PL.db.reset_tables
  end

  it "should return an array of playlist objects on success" do
    PL::CreateUser.run(name: "user1", password: "123")
    PL::CreateUser.run(name: "user2", password: "123")
    PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
    PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
    PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
    inputs = {username: "user1"}
    result = subject.run(inputs)
    expect(result.success?).to eq(true)
    expect(result.playlists).to be_a(Array)
    expect(result.playlists.first).to be_a(PL::Playlist)
    expect(result.playlists.first.name).to eq("playlist1")
    expect(result.playlists.first.username).to eq("user1")
    expect(result.playlists.last.name).to eq("playlist2")
    expect(result.playlists.last.username).to eq("user1")
  end

  it "should return error if user doesn't exist" do
    inputs = {username: "user1", name: "playlist1"}
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_does_not_exist)
  end

  it "should return error if no playlists for user" do
    PL::CreateUser.run({name: "user1", password: "123"})
    inputs = {username: "user1", name: "playlist1"}
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:no_playlists_found)
  end

end