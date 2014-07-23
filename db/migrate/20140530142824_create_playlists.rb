class CreatePlaylists < ActiveRecord::Migration
  def change
    # TODO
    create_table :playlists do |t|
      t.string :username
      t.string :name
    end
  end
end
