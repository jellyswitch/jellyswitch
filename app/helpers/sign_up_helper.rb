# typed: false
module SignUpHelper
  def display_price(priceable)
    if priceable
      number_to_currency(priceable.amount_in_cents.to_f / 100.0)
    end
  end
end
