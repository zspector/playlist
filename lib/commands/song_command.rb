module PL
  class SongCommand < Command
    # inputs = { username: "user1",name: "playlist1"}
    # returns array of Playlist objects
    # def run(inputs)

    #   user = PL.db.get_user_by_name(inputs[:username])
    #   return failure(:user_does_not_exist) if user.nil?

    #   playlists = PL.db.get_playlist(inputs)
    #   return failure(:no_playlists_found) if playlists.nil?

    #   success(:playlists => playlists)
    # end

    def add(inputs)
      # inputs = { playlist_id: 1, name: "song1", artist: "artist1", url: "www.song1.com" }

      playlist = PL.db.get_playlist(id: inputs[:playlist_id])
      return failure(:playlist_does_not_exist) if playlist.nil?
      song = PL.db.create_song(inputs)

      success(:song => song)
    end

    def self.delete(inputs)
      # inputs = {song_id: 1}
      song = PL.db.get_song(id: inputs[:song_id])
      return failure(:song_does_not_exist) if song.nil?

      PL.db.delete_song(inputs[:song_id])

      success()

    end

    def self.edit
    end
    
  end
end