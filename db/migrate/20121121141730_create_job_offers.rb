class CreateJobOffers < ActiveRecord::Migration

  # JobOffers - Modelo que guarda as propostas de emprego de cada Empresa
  #
  # job_offer = Cargo proposto (exemplo: Junior Java Developer , Cook, Junior Manager)
  # description = Um resumo do cargo (exemplo: Google procura um Junior Java Developer para trabalho no Bangladesh)
  # required_education = Requisitos de formação prévia, pode ser grau académico ou emprego prévio (exemplo: Master
  #                      Degree in Computer Science, First Certificate in English)
  # skills = Habilidades necessárias (exemplo: Java Programming, Cooking, Group Management)
  # active = Flag que indica que a oferta ainda se encontra activa (MUDADO PARA status EM VERSÃO POSTERIOR)
  # conditions = Contrapartidas oferecidas pela empresa (exemplo: monthly salary = 5000€ , free mobile phone...)


  def change
    create_table :job_offers do |t|
      t.string :job_name
      t.text :description
      t.text :required_education
      t.text :skills
      t.boolean :active
      t.text :conditions
      t.integer :company_id

      t.timestamps
    end
  end
end
