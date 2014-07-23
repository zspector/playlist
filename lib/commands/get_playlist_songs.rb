require 'pry-debugger'

module PL
  class GetPlaylistSongs < Command
    def run(inputs)
      PL::SanitizeInput.run(inputs)
      # inputs = { playlist_id: 1, name: "song1", artist: "artist1", url: "www.song1.com" }

      playlist = PL.db.get_playlist(id: inputs[:playlist_id])
      return failure(:playlist_does_not_exist) if playlist.nil?

      songs = PL.db.get_playlist_songs(inputs[:playlist_id])
      return failure(:no_songs_in_playlist) if songs.nil?

      success(:songs => songs)
    end
  end
end
