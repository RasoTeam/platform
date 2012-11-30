class ChangeTagToSlug < ActiveRecord::Migration
  def change
    rename_column :companies, :tag, :slug
  end
end
