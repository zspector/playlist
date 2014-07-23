module PL
  class CreatePlaylist < Command
    # inputs = { name: "Rock",params[:username]}
    def run(inputs)
      # binding.pry
      PL::SanitizeInput.run(inputs)

      playlists = PL.db.get_playlist(username: inputs[:username], name: inputs[:name])
      return failure(:playlist_taken) if playlists

      playlist = PL.db.create_playlist(inputs)
      return failure(:playlist_not_stored) if playlist.nil?

      success(:playlist => playlist)
    end
  end
end
