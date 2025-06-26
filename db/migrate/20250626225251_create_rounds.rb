class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.string :result

      t.timestamps
    end
  end
end
