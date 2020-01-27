class AddStiTypeToDailyUpdates < ActiveRecord::Migration[5.0]
  def change
    add_column :daily_updates, :type, :string
  end
end
