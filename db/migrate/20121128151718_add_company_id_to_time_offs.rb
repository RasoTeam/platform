class AddCompanyIdToTimeOffs < ActiveRecord::Migration
  def change
    add_column :time_offs, :company_id, :integer
  end
end
