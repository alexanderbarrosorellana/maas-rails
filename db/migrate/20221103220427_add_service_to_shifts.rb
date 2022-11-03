class AddServiceToShifts < ActiveRecord::Migration[7.0]
  def change
    add_reference :shifts, :service, null: false, foreign_key: true
  end
end
