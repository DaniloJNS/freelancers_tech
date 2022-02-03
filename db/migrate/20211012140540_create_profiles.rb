class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :social_name
      t.text :description
      t.date :birth_date

      t.timestamps
    end
  end
end
