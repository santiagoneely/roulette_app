class AddProfileToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :profile, :string
  end
end
