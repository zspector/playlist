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
    return nil if record.empty?
    data = {}
    data[:id] = record.first.first
    data[:name] = record.first[1]
    data[:password] = record.first.last.to_s
    build_user(data)
  end

  def get_user_by_id(id)
    record = @db.execute <<-SQL
    SELECT * FROM users WHERE id='#{id}';
    SQL
    return nil if record.empty?
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

  def get_playlist(data)
    if data.size == 0
      return nil
    elsif data.size == 1
      records = []
      data.each do |key, value|
        records = @db.execute"
        SELECT * FROM playlists WHERE #{key.to_s} = ?", value
        return nil if records.empty?

        records.map! do |record|
          x = {}
          x[:id] = record.first
          x[:username] = record[1]
          x[:name] = record.last
          build_playlist(x)
        end
        return records
      end
    elsif data.size == 2
      records = []
      keys = data.keys
      values = data.values
      records = @db.execute "
      SELECT * FROM playlists WHERE #{keys[0]} = '#{values[0]}' AND #{keys[1]} = '#{values[1]}';"
      return nil if records.empty?
      records.map! do |record|
        x = {}
        x[:id] = record.first
        x[:username] = record[1]
        x[:name] = record.last
        build_playlist(x)
      end
      return records
    else
      return nil
    end
  end

  def get_playlist_by_name(name)
    record = @db.execute <<-SQL
    SELECT * FROM playlists WHERE name='#{name}';
    SQL
    return nil if record.empty?
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
    return nil if record.empty?
    data = {}
    data[:id] = record.first.first
    data[:username] = record.first[1]
    data[:name] = record.first.last
    build_playlist(data)
  end

  def update_playlist(data)
    result = @db.execute <<-SQL
    UPDATE playlists SET name = '#{data[:name]}' WHERE id = #{data[:id]};
    SQL
    get_playlist_by_id(data[:id])
  end

  def delete_playlist(id)
    @db.execute <<-SQL
    DELETE FROM playlists WHERE id = #{id};
    SQL
  end

  ###########
  ## Songs ##
  ###########

  def build_song(data)
    PL::Song.new(data)
  end

  def create_song(data)
    @db.execute <<-SQL
    INSERT INTO songs (playlist_id, artist, name, url) VALUES (#{data[:playlist_id]}, '#{data[:artist]}', '#{data[:name]}', '#{data[:url]}');
    SQL

    id = @db.execute("SELECT last_insert_rowid();").first.first
    data[:id] = id
    build_song(data)
  end

  def get_song(id)
    # binding.pry
    record = @db.execute "
    SELECT * FROM songs WHERE id=?;
    ", id
    return nil if record.empty?
    data = {}
    data[:id] = record.first.first
    data[:playlist_id] = record.first[1]
    data[:artist] = record.first[2]
    data[:name] = record.first[3]
    data[:url] = record.first.last
    build_song(data)
  end

  def get_playlist_songs(playlist_id)
    records = @db.execute"
    SELECT * FROM songs WHERE playlist_id = ?;", playlist_id

      records.map! do |record|
        x = {}
        x[:id] = record.first
        x[:playlist_id] = record[1]
        x[:artist] = record[2]
        x[:name] = record[3]
        x[:url] = record.last
        build_song(x)
      end
      return records
  end

  def update_song(data)
    # .each throug key value pairs of hash
    data.each do |key, value|
      result = @db.execute "
      UPDATE songs SET '#{key.to_s}' = ? WHERE id = ?;
      ", value, data[:id]
    end

    get_song(data[:id])
  end

  def delete_song(id)
    @db.execute "
    DELETE FROM songs WHERE id = ?;
    ", id
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
