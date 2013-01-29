class AddStatusToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :status, :string , :default => 'Awaiting Interview'
  end
end
