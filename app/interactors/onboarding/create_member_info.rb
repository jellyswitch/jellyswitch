class Onboarding::CreateMemberInfo
  include Interactor
  include ErrorsHelper

  delegate :location, :wifi_name, :wifi_password, :contact_name, :contact_phone, :contact_email, to: :context

  def call
    location.wifi_name = wifi_name
    location.wifi_password = wifi_password
    location.contact_name = contact_name
    location.contact_phone = contact_phone
    location.contact_email = contact_email

    if location.save
      context.location = location
    else
      context.fail!(message: errors_for(location))
    end
  end
end