class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :r_approval
      t.string :r_request

      t.timestamps
    end
  end
end
