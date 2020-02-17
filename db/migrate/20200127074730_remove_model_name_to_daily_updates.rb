class RemoveModelNameToDailyUpdates < ActiveRecord::Migration[5.0]
  def change
    remove_column :daily_updates, :model_name_to_update
  end
end
