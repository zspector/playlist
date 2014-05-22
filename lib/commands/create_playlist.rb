module PL
  class CreatePlaylist < Command
    # inputs = { name: "Rock",params[:username]}
    def run(inputs)
      get_playlists_from_user()
      playlists = PL.db.get_playlist_by_name(inputs[:name])

      return failure(:name_taken) if playlists
      
      user = PL.db.create_user(inputs)
      return failure(:user_info_not_stored) if user.nil?
      
      success(:user => user)
    end
  end
end