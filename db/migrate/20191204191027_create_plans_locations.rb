class CreatePlansLocations < ActiveRecord::Migration[5.2]
  def change
    # create join table
    create_table :locations_plans, id: false do |t|
      t.belongs_to :plan
      t.belongs_to :location
    end

    # assign all plans to all locations for each operator
    Plan.all.each do |plan|
      plan.operator.locations.each do |location|
        plan.locations << location
      end
    end
  end
end
