require 'spec_helper'
require 'pry-debugger'

describe PL::GetPlaylistSongs do
  before (:each) do
    PL.db.reset_tables
  end

  it "should return an array of song objects" do
    PL::CreateUser.run(name: "user1", password: "123")
    PL::CreateUser.run(name: "user2", password: "123")
    PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
    PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
    PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
    binding.pry
    PL::SongCommand.add(name: "song1", artist: "artist1", url: "www.song1.com", playlist_id: 1)
    PL::SongCommand.add(name: "song2", artist: "artist1", url: "www.song2.com", playlist_id: 1)
    PL::SongCommand.add(name: "song3", artist: "artist1", url: "www.song3.com", playlist_id: 2)
    
    inputs = {playlist_id: 1}
    result = subject.run(inputs)

    expect(result.success?).to eq(true)

    expect(result.songs).to be_a(Array)
    expect(result.songs.length).to eq(2)
    expect(result.songs.first).to be_a(PL::Song)
    expect(result.songs.first.name).to eq("song1")
    expect(result.songs.last.name).to eq("song2")
  end

  it "should return failure if playlist does not exist" do 
    inputs = {playlist_id: 1}
    result = subject.run(inputs)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:playlist_does_not_exist)
  end
end