class MakeFlaggable < ActiveRecord::Migration
  def change
    create_table :favorite_songs do |t|
      t.integer :user_id, null: false
      t.integer :song_id, null: false
    end 
  end
end
