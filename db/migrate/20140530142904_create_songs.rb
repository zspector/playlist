class CreateSongs < ActiveRecord::Migration
  def change
    # TODO
    create_table :songs do |t|
      t.integer :playlist_id
      t.string :artist
      t.string :name
      t.string :url
    end
  end
end
