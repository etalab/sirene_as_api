class AddUpdateTypeToDailyUpdate < ActiveRecord::Migration[5.0]
  def change
    add_column :daily_updates, :update_type, :string, default: 'limited'
  end
end
