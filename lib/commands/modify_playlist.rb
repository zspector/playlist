module PL
  class ModifyPlaylist < Command

    def get(inputs)
      PL::SanitizeInput.run(inputs)
      playlist = PL.db.get_playlist_by_id(inputs[:id])
      return failure(:playlist_not_found) if playlist.nil?

      success(:playlist => playlist)
    end

    def edit(inputs)
      PL::SanitizeInput.run(inputs)

      user = PL.db.get_user_by_name(inputs[:username])
      return failure(:user_does_not_exist) if user.nil?

      playlist1 = PL.db.get_playlist_by_id(inputs[:id])
      return failure(:playlist_does_not_exist) if playlist1.nil?

      playlist2 = PL.db.update_playlist(inputs)

      return failure(:playlist_not_updated) if playlist1.instance_variables != playlist2.instance_variables

      success(playlist: playlist2)
    end

    def delete(inputs)
      PL::SanitizeInput.run(inputs)

      user = PL.db.get_user_by_name(inputs[:username])
      return failure(:user_does_not_exist) if user.nil?

      playlist1 = PL.db.get_playlist_by_id(inputs[:id])
      return failure(:playlist_does_not_exist) if playlist1.nil?

      songs = PL.db.get_playlist_songs(inputs[:id])
      songs.each do |song|
        PL.db.delete_song(song.id)
      end

      PL.db.delete_playlist(inputs[:id])

      success

    end
  end
end
