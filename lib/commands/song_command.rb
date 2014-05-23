require 'pry-debugger'

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

    def delete(inputs)
      # inputs = {song_id: 1}
      # binding.pry
      song = PL.db.get_song(inputs[:id])
      return failure(:song_does_not_exist) if song.nil?

      PL.db.delete_song(inputs[:id])

      success(song: song)

    end

    def edit(inputs)
      # inputs = {id: 1, name: , artist: , etc.}
      song1 = PL.db.get_song(inputs[:id])
      return failure(:song_does_not_exist) if song1.nil?

      song2 = PL.db.update_song(inputs)

      return failure(:song_not_updated) if song1.instance_variables != song2.instance_variables

      success(song: song2)

    end

  end
end