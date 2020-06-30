class MoveFromHoursToMinutes < ActiveRecord::Migration[5.2]
  def up
    add_column :reservations, :minutes, :integer, null: false, default: 0
    Reservation.all.each do |res|
      res.update(minutes: res.hours * 60)
    end
  end

  def down
    remove_column :reservations, :minutes
  end
end
