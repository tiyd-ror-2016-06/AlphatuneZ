class AddSuggestDateColumnToSongsTable < ActiveRecord::Migration
  def change
    add_column :songs, :suggested_date, :datetime
  end
end
