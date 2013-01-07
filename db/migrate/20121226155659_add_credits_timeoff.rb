class AddCreditsTimeoff < ActiveRecord::Migration
  def change
    add_column :time_offs, :total_credits, :integer
  end
end
