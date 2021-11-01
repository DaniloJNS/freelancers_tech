class CreateExperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :experiences do |t|
      t.string :company, null: false
      t.string :office, null: false
      t.string :description, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :current_job, default: false

      t.timestamps
    end
  end
end
