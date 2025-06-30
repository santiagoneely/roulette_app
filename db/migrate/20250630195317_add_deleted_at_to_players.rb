class AddDeletedAtToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :deleted_at, :datetime
    add_index :players, :deleted_at
  end
end
