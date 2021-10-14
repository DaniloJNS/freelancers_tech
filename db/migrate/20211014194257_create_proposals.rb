class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.text :justification
      t.decimal :price_hour
      t.integer :weekly_hour
      t.date :completion_deadline

      t.timestamps
    end
  end
end
