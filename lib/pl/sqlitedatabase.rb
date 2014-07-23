require 'active_record'

class SQLiteDatabase
  def initialize
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => 'pl-test.db'
    )
  end

  class User < ActiveRecord::Base
    has_many :playlists
  end

  class Playlist < ActiveRecord::Base
    belongs_to :users
    has_many :songs
  end

  class Songs < ActiveRecord::Base
    belongs_to :playlists
  end

  ###########
  ## Users ##
  ###########

  def build_user(data)
    PL::User.new(data)
  end

  def create_user(attrs)
    ar_user = User.create(attrs)
    build_user(ar_user)
  end

  def get_user_by_name(name)
    ar_user = User.find_by(name: name)
    build_user(ar_user)
  end

  def get_user_by_id(id)
    ar_user = User.find(id)
    build_user(ar_user)
  end

  def update_user(data)
    ar_user = User.update_attributes(data)
    build_user(ar_user)
  end

  def delete_user(name)
    User.find_by(name: name).destroy
  end

  ##############
  ## Playlist ##
  ##############

  def build_playlist(data)
    PL::Playlist.new(data)
  end

  def create_playlist(attrs)
    ar_playlist = Playlist.new(attrs)
    build_playlist(ar_playlist)
  end

  def get_playlist(data)

  end

  ##########
  ## Song ##
  ##########

  def create_song(attr)
    ar_song = Song.new(attrs)
    PL::Song.new(ar_song.attributes)
  end
end
