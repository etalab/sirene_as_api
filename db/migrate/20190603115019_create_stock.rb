class CreateStock < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string :year
      t.string :month
      t.string :status
      t.string :uri

      t.timestamps
    end
  end
end
