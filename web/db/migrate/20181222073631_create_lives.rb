class CreateLives < ActiveRecord::Migration[5.2]
  def change
    create_table :lives do |t|
      t.string :name
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
