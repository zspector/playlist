require 'spec_helper'
require 'pry-debugger'

describe PL::SongCommand do
  before (:each) do
    PL.db.reset_tables
  end
  
  describe "add command" do 
    it "should return a song object on success" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
      PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
      inputs = { playlist_id: 1, name: "song1", artist: "artist1", url: "www.song1.com" }
      result = subject.add(inputs)
      expect(result.success?).to eq(true)
      expect(result.song).to be_a(PL::Song)
      expect(result.song.id).to eq(1)
      expect(result.song.playlist_id).to eq(1)
      expect(result.song.name).to eq(inputs[:name])
      expect(result.song.artist).to eq(inputs[:artist])
      expect(result.song.url).to eq(inputs[:url])
    end

    it "should return error if playlist does not exist" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
      PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
      
      inputs = { playlist_id: 9000, name: "song1", artist: "artist1", url: "www.song1.com" }
      result = subject.add(inputs)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:playlist_does_not_exist)
    end
  end

  describe "delete command" do 
    it "should delete the right song" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
      PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
      input1 = { playlist_id: 1, name: "song1", artist: "artist1", url: "www.song1.com" }
      input2 = { playlist_id: 1, name: "song2", artist: "artist1", url: "www.song2.com" }
      subject.add(input1)
      subject.add(input2)
      songs = PL.db.get_playlist_songs(1)
      expect(songs.size).to eq(2)
      # delete song
      input1[:id] = songs.first.id
      result = subject.delete(input1)
      expect(result.success?).to eq(true)
      songs = PL.db.get_playlist_songs(1)
      expect(songs.size).to eq(1)
    end

    it "should return error if song not found" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist2"})
      PL::CreatePlaylist.run({username: "user2", name: "playlist1"})
      input1 = { playlist_id: 1, name: "song1", artist: "artist1", url: "www.song1.com" }
      subject.add(input1)
      input1[:id] = 100
      result = subject.delete(input1)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:song_does_not_exist)
      songs = PL.db.get_playlist_songs(1)
      expect(songs.size).to eq(1)
    end
  end

end