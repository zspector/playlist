require 'sqlite3'
require 'pry-debugger'

class PL::DB
  def initialize
    @db = SQLite3::Database.new 'test.db'

    @db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS users(
      id INTEGER,
      name string,
      password string,
      PRIMARY KEY ( id )
      );
    SQL

    @db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS playlists(
      id INTEGER,
      user_id INTEGER,
      name string,
      FOREIGN KEY ( user_id )
        REFERENCES users( id ),
      PRIMARY KEY ( id )
      );
    SQL

    @db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS songs(
      id INTEGER,
      playlist_id INTEGER,
      artist string,
      name string,
      url string,
      FOREIGN KEY ( playlist_id )
        REFERENCES playlists( id ),
      PRIMARY KEY ( id )
        );
    SQL
  end

  ###########
  ## Users ##
  ###########

  def build_user(data)
    PL::User.new(data)
  end

  def create_user(data)
    @db.execute <<-SQL
    INSERT INTO users (name, password) VALUES ('#{data[:name]}', '#{data[:password]}');
    SQL

    id = @db.execute("SELECT last_insert_rowid();").first.first
    data[:id] = id
    build_user(data)
  end

  def get_user
  end

  def update_user
  end

  def delete_user
  end

  ###############
  ## Playlists ##
  ###############

  def build_playlist
  end

  def create_playlist
  end

  def get_playlist
  end

  def update_playlist
  end

  def delete_playlist
  end

  ###########
  ## Songs ##
  ###########

  def build_song
  end

  def create_song
  end

  def get_song
  end

  def update_song
  end

  def delete_song
  end

  def get_all_tables
    tables = @db.execute(
      <<-SQL
      SELECT * FROM sqlite_master WHERE type='table';
      SQL
      )
    tables.map{|x| x[1]}
  end

  def reset_tables
    tables = get_all_tables
    tables.each do |name|
      # interpolated name with or without quotes?
      @db.execute("DROP TABLE '#{name}'")
    end
    initialize
  end
end

module PL
  def self.db
    @__db_instance ||= DB.new
  end
end
