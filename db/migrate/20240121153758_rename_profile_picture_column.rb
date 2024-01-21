class RenameProfilePictureColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :profilePicture, :profile_picture
  end
end
