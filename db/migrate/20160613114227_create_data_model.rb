class CreateDataModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.boolean :premium, null: false, default: false
      t.string :spotify_name
      t.string :spotify_id
    end

    create_table :songs do |t|
      t.string :title, null: false
      t.string :artist
      t.string :genre
      t.string :spotify_id
      t.integer :suggester_id, null: false
    end

    create_table :votes do |t|
      t.integer :song_id, null: false
      t.integer :user_id, null: false
      t.integer :value, null: false
      t.datetime :placed_at
    end

    create_table :playlists do |t|
      t.datetime :created_at, null: false
      t.string   :title
    end

    create_table :playlist_songs do |t|
      t.integer :playlist_id, null: false
      t.integer :song_id, null: false
    end
  end
end
