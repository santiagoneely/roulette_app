class AddOriginToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :origin, :string
  end
end
