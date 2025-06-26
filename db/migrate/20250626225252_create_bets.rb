class CreateBets < ActiveRecord::Migration[8.0]
  def change
    create_table :bets do |t|
      t.integer :amount
      t.string :color
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true

      t.timestamps
    end
  end
end
