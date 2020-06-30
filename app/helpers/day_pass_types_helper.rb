# typed: false
module DayPassTypesHelper
  def day_pass_type_options(day_pass_types)
    day_pass_types.map do |day_pass_type|
      [
        "#{day_pass_type.name} (#{number_to_currency(day_pass_type.amount_in_cents.to_f / 100.00)})",
        day_pass_type.id,
      ]
    end
  end

  def day_pass_type_params
    p = params.require(:day_pass_type).permit(:name, :amount_in_cents, :available, :visible, :always_allow_building_access, :code, :description)
    dollars = Money.from_amount(p[:amount_in_cents].to_i, "USD")
    p[:amount_in_cents] = dollars.cents
    p
  end


  def day_pass_type_update_params
    params.require(:day_pass_type).permit(:code, :description)
  end
end
