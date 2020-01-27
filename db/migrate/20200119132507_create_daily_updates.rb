class CreateDailyUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_updates do |t|
      t.string :status
      t.string :model_name_to_update
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
