class Onboarding::CreateDerivedLocation
  include Interactor
  include ErrorsHelper

  delegate :user, :name, :operator_name, :operator, to: :context

  def call
    loc = operator.locations.new(
      name: operator_name,
      snippet: "The best flexible workspace on planet earth!",
      square_footage: nil,
      building_address: nil,
      city: nil,
      state: nil,
      zip: nil,
      contact_name: user.name,
      contact_phone: nil,
      contact_email: user.email,
      wifi_name: nil,
      wifi_password: nil
    )

    if loc.save
      context.location = loc
    else
      context.fail!(message: errors_for(loc))
    end
  end

  def rollback
    context.location.destroy!
  end
end