class ChangeColumnActiveToStatus < ActiveRecord::Migration

  #Alteração da coluna active para agradar ao pessoal do Design...
  def change
    rename_column :job_offers , :active , :status
    change_column :job_offers , :status , :string
  end
end
