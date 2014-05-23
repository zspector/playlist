module PL
  class ShowPlaylists < Command
    # inputs = { username: "user1",name: "playlist1"}
    # returns array of Playlist objects
    def run(inputs)

      user = PL.db.get_user_by_name(inputs[:username])
      return failure(:user_does_not_exist) if user.nil?
      
      playlists = PL.db.get_playlist(inputs)
      return failure(:no_playlists_found) if playlists.nil?
      
      success(:playlists => playlists)
    end
  end
end