class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :report_name
      t.integer :quantity
      t.string :hdd_type

      t.timestamps
    end
  end
end
