require 'sqlite3'
require 'pry-debugger'

class PL::DB
  attr_reader :db
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
      username string,
      name string,
      FOREIGN KEY ( username )
        REFERENCES users( name ),
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

  ## can we combine get_user_by_name and get_user_by_id
  def get_user_by_name(name)
    record = @db.execute <<-SQL
    SELECT * FROM users WHERE name='#{name}';
    SQL
    data = {}
    data[:id] = record.first.first
    data[:name] = record.first[1]
    data[:password] = record.first.last
    build_user(data)
  end

  def get_user_by_id(id)
    record = @db.execute <<-SQL
    SELECT * FROM users WHERE id='#{id}';
    SQL
    data = {}
    data[:id] = record.first.first
    data[:name] = record.first[1]
    data[:password] = record.first.last
    build_user(data)
  end

  def update_user(data)
    @db.execute <<-SQL
    UPDATE users SET password = '#{data[:password]}' WHERE name = '#{data[:name]}'
    SQL

    get_user_by_name(data[:name])
  end

  def delete_user(name)
    @db.execute <<-SQL
    DELETE FROM users WHERE name = '#{name}';
    SQL
  end

  ###############
  ## Playlists ##
  ###############

  def build_playlist(data)
    PL::Playlist.new(data)
  end

  def create_playlist(data)
    @db.execute <<-SQL
    INSERT INTO playlists (name, username) VALUES ('#{data[:name]}', '#{data[:username]}');
    SQL

    id = @db.execute("SELECT last_insert_rowid();").first.first
    data[:id] = id
    build_playlist(data)
  end

  def get_playlist_by_name(name)
    record = @db.execute <<-SQL
    SELECT * FROM playlists WHERE name='#{name}';
    SQL
    data = {}
    data[:id] = record.first.first
    data[:username] = record.first[1]
    data[:name] = record.first.last
    build_playlist(data)
  end

  def get_playlist_by_id(id)
    record = @db.execute <<-SQL
    SELECT * FROM playlists WHERE id='#{id}';
    SQL
    data = {}
    data[:id] = record.first.first
    data[:username] = record.first[1]
    data[:name] = record.first.last
    build_playlist(data)
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
