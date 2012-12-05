class AddUserPhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_photo, :string
  end
end
