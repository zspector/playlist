class CreateUsers < ActiveRecord::Migration
  def change
    # TODO
    create_table :users do |t|
      t.string :name
      t.string :password
    end
  end
end
