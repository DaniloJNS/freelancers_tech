class CreateFormations < ActiveRecord::Migration[6.1]
  def change
    create_table :formations do |t|
      t.string :university
      t.date :conclusion
      t.date :start
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
