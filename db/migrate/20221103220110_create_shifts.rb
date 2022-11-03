class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.boolean :assigned, default: false
      t.time :start_time
      t.time :end_time
      t.date :date

      t.timestamps
    end
  end
end
