require 'spec_helper'
require 'pry-debugger'

describe PL::ModifyPlaylist do
  before (:each) do
    PL.db.reset_tables
  end

  describe "edit playlist command" do
    it "should update the right playlist" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      inputs = {id: 1, username: "user1", name: "playlist"}
      result = subject.edit(inputs)
      # binding.pry
      # input1[:id] = playlist.id
      # input1[:name] = "playlist"
      # input1[:url] = "www.song2.com"
      # song2 = subject.edit(input1)
      # song2 = PL.db.update_song(input1)
      playlist2 = PL.db.get_playlist_by_id(1)
      expect(result.playlist).to be_a(PL::Playlist)
      expect(playlist2.id).to eq(1)
      expect(playlist2.name).to eq("playlist")
      expect(playlist2.username).to eq("user1")
    end

    it "should return error if user does not exist" do
      input = {name: "playlist", username: "user"}
      result = subject.edit(input)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_does_not_exist)
    end

    it "should return error if playlist does not exist" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      input = {name: "playlist", username: "user1"}
      result = subject.edit(input)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:playlist_does_not_exist)
    end
  end

  describe "delete playlist command" do
    it "should delete the right playlist" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreateUser.run(name: "user2", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist2"})

      input1 = { id: 1, name: "playlist1", username: "user1" }
      # input2 = { id: 2, name: "playlist2", username: "user1" }
      result = subject.delete(input1)
      # subject.delete(input2)
      playlists = PL.db.get_playlist(username: "user1")
      expect(result.success?).to eq(true)
      expect(playlists.size).to eq(1)
      expect(playlists.first.id).to eq(2)
    end

    it "should delete all songs on playlist" do
      PL::CreateUser.run(name: "user1", password: "123")
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::CreatePlaylist.run({username: "user1", name: "playlist1"})
      PL::SongCommand.add(name: "song1", artist: "artist1", url: "www.song1.com", playlist_id: 1)
      PL::SongCommand.add(name: "song2", artist: "artist1", url: "www.song2.com", playlist_id: 1)
      input1 = { id: 1, name: "playlist1", username: "user1" }
      result = subject.delete(input1)
      expect(result.success?).to eq(true)

      song1 = PL.db.get_song(1)
      song2 = PL.db.get_song(2)
      expect(song1).to be(nil)
      expect(song2).to be(nil)
    end

    it "should return error if username does not exist" do
      input1 = { id: 1, name: "playlist1", username: "user1" }
      result = subject.delete(input1)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_does_not_exist)
    end

    it "should return error if playlist is not found" do
      PL::CreateUser.run(name: "user1", password: "123")
      input1 = { id: 1, name: "playlist1", username: "user1" }
      result = subject.delete(input1)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:playlist_does_not_exist)
    end
  end
end
