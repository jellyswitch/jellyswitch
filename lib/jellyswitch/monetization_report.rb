# typed: true
class Jellyswitch::MonetizationReport
  attr_reader :location

  def initialize(location)
    @location = location
  end

  def office_income
    @office_income ||= location.offices.map do |office|
      income = office.office_leases.active.map(&:subscription).map(&:plan).flatten.sum {|p| p.amount_in_cents }.to_f / 100.0
      income_per_square_foot = income / office.square_footage

      office_income_klass.new(
        office,
        office.name,
        office.square_footage,
        income,
        income_per_square_foot
      )
    end
  end

  def total_office_income
    square_footage = office_income.sum { |o| o.square_footage }
    income = office_income.sum{ |o| o.income }
    income_per_square_foot = square_footage == 0 ? 0 : income / square_footage

    @total_office_income ||= office_income_klass.new(
      nil,
      "Total Offices",
      square_footage,
      income,
      income_per_square_foot
    )
  end

  def room_income
    @room_income ||= location.rooms.map do |room|
      room_income_klass.new(
        room,
        room.name,
        room.square_footage,
        0,
        0
      )
    end
  end

  def total_room_income
    @total_room_income  ||= room_income_klass.new(
      nil,
      "Total Rooms",
      room_income.sum {|r| r.square_footage},
      0,
      0
    )
  end

  def flex_income
    @flex_income ||= location.operator.plans.individual.map do |plan|
      income = plan.subscriptions.active.count * (plan.amount_in_cents.to_f / 100.0)

      flex_income_klass.new(
        plan,
        plan.name,
        0,
        income,
        0
      )

    end
  end

  def total_flex_income
    income = flex_income.sum {|f| f.income }
    income_per_square_foot = income.to_f / location.flex_square_footage

    @total_flex_income ||= flex_income_klass.new(
      nil,
      "Total Flex Income",
      location.flex_square_footage,
      income,
      income_per_square_foot
    )
  end

  def total_income
    vals = [total_flex_income, total_office_income]

    incomes_per_square_foot = vals.map(&:income_per_square_foot)
    avg_income_per_sq_ft = incomes_per_square_foot.inject { |sum, el| sum + el }.to_f / incomes_per_square_foot.count

    income_klass.new(
      vals.sum { |v| v.square_footage },
      vals.sum { |v| v.income },
      avg_income_per_sq_ft
    )
  end

  def chart_data
    {
      "Offices" => total_office_income.income_per_square_foot.round(2),
      "Flex Space" => total_flex_income.income_per_square_foot.round(2)
    }
  end

  private

  def office_income_klass
    Struct.new(:office, :name, :square_footage, :income, :income_per_square_foot)
  end

  def room_income_klass
    Struct.new(:room, :name, :square_footage, :income, :income_per_square_foot)
  end

  def flex_income_klass
    Struct.new(:plan, :name, :square_footage, :income, :income_per_square_foot)
  end

  def income_klass
    Struct.new(:square_footage, :income, :income_per_square_foot)
  end
end