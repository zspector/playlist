require 'spec_helper'
require 'pry-debugger'

########
## DB ##
########

describe 'db' do
  let(:db) do
    PL.db.reset_tables
    PL.db
  end

  let (:user1) do
    data = {
      name: "user1",
      password: "abcd"
    }
    db.create_user(data)
  end

  let (:user2) do
    data = {
      name: "user2",
      password: "123"
    }
    db.create_user(data)
  end

  let (:playlist1) do
    data = {
      name: "playlist1",
      username: "user1"
    }
    db.create_playlist(data)
  end

  let (:playlist2) do
    data = {
      name: "playlist2",
      username: "user1"
    }
    db.create_playlist(data)
  end

  let (:playlist3) do
    data = {
      name: "playlist3",
      username: "user2"
    }
    db.create_playlist(data)
  end

  let(:song1) do
    data = {
      playlist_id: 1,
      artist: "artist1",
      name: "song1",
      url: "www.song1.com"
    }
    db.create_song(data)
  end

  let(:song2) do
    data = {
      playlist_id: 1,
      artist: "artist1",
      name: "song2",
      url: "www.song2.com"
    }
    db.create_song(data)
  end

  let(:song3) do
    data = {
      playlist_id: 2,
      artist: "artist2",
      song: "song2",
      url: "www.song3.com"
    }
    db.create_song(data)
  end

  let(:song4) do
    data = {
      playlist_id: 3,
      artist: "artist3",
      song: "song4",
      url: "www.song4.com"
    }
    db.create_song(data)
  end
  it 'exits' do
    expect(DB).to be_a(Class)
    db
  end

  it 'returns a db' do
    expect(db).to be_a(DB)
  end

  xit 'has the correct tables' do

  end

  it 'is a singleton' do
    db1 = PL.db
    db2 = PL.db
    expect(db1).to be(db2)
  end

  it 'has the correct number of tables' do
    tables = db.get_all_tables
    expect(tables.size).to eq(3)
    expect(tables).to include("users", "playlists", "songs")
  end

  describe 'users' do

    describe 'build_user' do
      it 'should build a user object' do
        user = db.build_user(name: "user", password: "abcd")
        expect(user).to be_a(PL::User)
      end
    end

    describe 'create_user' do
      it 'adds a user record to db' do
        user1
        command = "SELECT * FROM users;"
        records = db.db.execute(command)
        expect(records.size).to eq(1)
      end

      it 'creates user in db with correct attributes' do
        user1
        command = "SELECT * FROM users;"
        records = db.db.execute(command)
        expect(records.first.size).to eq(3)
        expect(records.first.first).to eq(1)
        expect(records.first[1]).to eq("user1")
        expect(records.first.last).to eq("abcd")
      end
    end

    describe 'get_user_by_name' do
      it 'return user object' do
        user1
        expect(db.get_user_by_name("user1")).to be_a(PL::User)
      end

      it 'gets user with correct attributes' do
        user1
        user2
        result = db.get_user_by_name("user1")

        expect(result.name).to eq("user1")
        expect(result.password).to eq("abcd")
      end
    end

    describe 'get_user_by_id' do
      it 'returns a user object' do
        user1
        expect(db.get_user_by_id(1)).to be_a(PL::User)
      end

      it 'gets user with correct attributes' do
        user1
        user2
        result = db.get_user_by_id(1)

        expect(result.name).to eq("user1")
        expect(result.password).to eq("abcd")
      end
    end

    describe 'update user' do
      it 'updates the database record' do
        user1
        db.update_user(name: "user1", password: "dcba")
        command = "SELECT * FROM users WHERE name='user1';"
        records = db.db.execute(command)
        expect(records.first.last).to eq("dcba")
      end

      it 'returns user object with updated attributes' do
        user1
        result = db.update_user(name: "user1", password: "dcba")

        expect(result.id).to eq(1)
        expect(result.name).to eq("user1")
        expect(result.password).to eq("dcba")
      end
    end

    describe 'delete user' do
      it 'deletes the correct database record' do
        user1
        user2
        command = "SELECT * FROM users;"
        records = db.db.execute(command)

        expect(records.size).to eq(2)

        db.delete_user("user1")
        command = "SELECT * FROM users;"
        records = db.db.execute(command)

        expect(records.size).to eq(1)
        expect(records.first[1]).to eq("user2")
      end
    end
  end

  describe 'playlists' do
    describe 'build_playlist' do
      it 'should build a playlist object' do
        playlist = db.build_playlist(name: "playlist1", username: "user1")
        expect(playlist).to be_a(PL::Playlist)
      end
    end

    describe 'create_playlist' do
      it 'adds a playlist record to db' do
        playlist1
        command = "SELECT * FROM playlists;"
        records = db.db.execute(command)
        expect(records.size).to eq(1)
      end

      it 'creates playlist in db with correct attributes' do
        playlist1
        command = "SELECT * FROM playlists;"
        records = db.db.execute(command)
        expect(records.first.size).to eq(3)
        expect(records.first.first).to eq(1)
        expect(records.first[1]).to eq("user1")
        expect(records.first.last).to eq("playlist1")
      end
    end

    describe 'get_playlist' do
      it 'returns a playlist object when given id' do
        user1
        playlist1
        playlist2

        result = db.get_playlist(id: 1)

        expect(result.first).to be_a(PL::Playlist)
      end

      it 'returns an array of playlist objects when given username' do
        user1
        user2
        playlist1
        playlist2
        playlist3
        result = db.get_playlist(username: "user1")

        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result.first).to be_a(PL::Playlist)
        expect(result.last).to be_a(PL::Playlist)
      end

      it 'returns correct record when given two attributes' do
        user1
        user2
        playlist1
        playlist2
        playlist3
        result = db.get_playlist(username: "user1", name: "playlist1")

        expect(result.length).to eq(1)
        expect(result.first).to be_a(PL::Playlist)
        expect(result.first.name).to eq("playlist1")
        expect(result.first.username).to eq("user1")
      end
    end

    describe 'get_playlist_by_name' do
      it 'return user object' do
        playlist1
        expect(db.get_playlist_by_name("playlist1")).to be_a(PL::Playlist)
      end

      it 'gets user with correct attributes' do
        user1
        playlist1
        playlist2
        result = db.get_playlist_by_name("playlist1")

        expect(result.name).to eq("playlist1")
        expect(result.username).to eq("user1")
      end
    end

    describe 'get_playlist_by_id' do
      it 'return user object' do
        playlist1
        expect(db.get_playlist_by_id(1)).to be_a(PL::Playlist)
      end

      it 'gets user with correct attributes' do
        user1
        playlist1
        playlist2
        result = db.get_playlist_by_id(1)

        expect(result.name).to eq("playlist1")
        expect(result.username).to eq("user1")
      end
    end

    describe 'update playlist' do
      it 'updates the database record' do
        user1
        playlist1
        playlist2
        db.update_playlist(id: 1, name: "playlist1", username: "user1")
        command = "SELECT * FROM playlists WHERE id=1;"
        records = db.db.execute(command)
        expect(records.first[1]).to eq("user1")
      end

      it 'returns playlist object with updated attributes' do
        user1
        playlist1
        playlist2
        result = db.update_playlist(id: 1, name: "playlist", username: "user1")

        expect(result.id).to eq(1)
        expect(result.name).to eq("playlist")
        expect(result.username).to eq("user1")
      end
    end

    describe 'delete_playlist' do
      it 'deletes the correct database record' do
        user1
        playlist1
        playlist2
        command = "SELECT * FROM playlists;"
        records = db.db.execute(command)

        expect(records.size).to eq(2)

        db.delete_playlist(1)
        command = "SELECT * FROM playlists;"
        records = db.db.execute(command)

        expect(records.size).to eq(1)
        expect(records.first[2]).to eq("playlist2")
      end
    end
  end

  describe 'songs' do
    describe 'build_song' do
      it 'should build a song object' do
        song = db.build_song(playlist_id: 1, artist: "artist", name: "user", url: "abcd")
        expect(song).to be_a(PL::Song)
      end
    end

    describe 'create_song' do
      it 'adds a song record to db' do
        user1
        playlist1
        song1
        command = "SELECT * FROM songs;"
        records = db.db.execute(command)
        expect(records.size).to eq(1)
      end

      it 'creates song in db with correct attributes' do
        user1
        playlist1
        song1
        command = "SELECT * FROM songs;"
        records = db.db.execute(command)
        expect(records.first.size).to eq(5)
        expect(records.first.first).to eq(1)
        expect(records.first[1]).to eq(1)
        expect(records.first[2]).to eq("artist1")
        expect(records.first[3]).to eq("song1")
        expect(records.first.last).to eq("www.song1.com")
      end
    end

    describe 'get_song' do
      it 'return song object' do
        user1
        playlist1
        song1
        expect(db.get_song(1)).to be_a(PL::Song)
      end

      it 'gets user with correct attributes' do
        user1
        playlist1
        playlist2
        playlist3
        song1
        song2
        song3
        song4
        result = db.get_song(1)

        expect(result.playlist_id).to eq(1)
        expect(result.artist).to eq("artist1")
        expect(result.name).to eq("song1")
        expect(result.url).to eq("www.song1.com")
      end
    end

    describe 'update song' do
      it 'updates the database record' do
        user1
        playlist1
        playlist2
        playlist3
        song1
        song2
        song3
        song4
        db.update_song(id: 1, playlist_id: 1, artist: "artist", name: "song1", url: "www.song1.com")
        command = "SELECT * FROM songs WHERE id=1;"
        records = db.db.execute(command)
        expect(records.first[2]).to eq("artist")
      end

      it 'returns playlist object with updated attributes' do
        user1
        playlist1
        playlist2
        playlist3
        song1
        song2
        song3
        song4
        result = db.update_song(id: 1, playlist_id: 1, artist: "artist", name: "song1", url: "www.song.com")

        expect(result.id).to eq(1)
        expect(result.playlist_id).to eq(1)
        expect(result.artist).to eq("artist")
        expect(result.name).to eq("song1")
        expect(result.url).to eq("www.song.com")
      end
    end

    describe 'delete_song' do
      it 'deletes the correct database record' do
        user1
        playlist1
        playlist2
        playlist3
        song1
        song2
        song3
        song4
        command = "SELECT * FROM songs;"
        records = db.db.execute(command)

        expect(records.size).to eq(4)

        db.delete_song(1)
        command = "SELECT * FROM songs;"
        records = db.db.execute(command)

        expect(records.size).to eq(3)
        expect(records.first[2]).to eq("artist1")
        expect(records.first[3]).to eq("song2")
      end
    end
  end
end



































# test
