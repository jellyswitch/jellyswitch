class Onboarding::CreateLocation
  include Interactor
  include ErrorsHelper

  delegate :operator, :name, :description, :square_footage, :street_address, :city, :state, :zip, :time_zone,
    :contact_name, :contact_email, :contact_phone, :wifi_name, :wifi_password, to: :context

  def call
    loc = operator.locations.new(
      name: name,
      snippet: description,
      square_footage: square_footage,
      building_address: street_address,
      city: city,
      state: state,
      zip: zip,
      time_zone: time_zone,
      contact_name: contact_name,
      contact_phone: contact_phone,
      contact_email: contact_email,
      wifi_name: wifi_name,
      wifi_password: wifi_password
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