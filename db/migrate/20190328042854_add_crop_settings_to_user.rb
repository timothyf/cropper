class AddCropSettingsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :crop_settings, :JSON
  end
end
