module RoomsHelper
  def room_params
    p = params.require(:room).permit(
      :name, 
      :description, 
      :whiteboard, 
      :capacity, 
      :square_footage, 
      :photo, 
      :visible, 
      :av,
      :rentable,
      :hourly_rate_in_cents,
      :credit_cost
      )
    dollars = Money.from_amount(p[:hourly_rate_in_cents].to_i, "USD")
    p[:hourly_rate_in_cents] = dollars.cents
    p
  end
end