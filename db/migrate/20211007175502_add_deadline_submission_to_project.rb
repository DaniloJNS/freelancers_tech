class AddDeadlineSubmissionToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :deadline_submission, :date
  end
end
