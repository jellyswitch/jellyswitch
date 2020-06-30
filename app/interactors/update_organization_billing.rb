# typed: true
class UpdateOrganizationBilling
  include Interactor

  delegate :organization, :stripe_token, :out_of_band, to: :context

  def call
    if out_of_band
      organization.update(out_of_band: true)
    else
      stripe_customer = organization.find_or_create_stripe_customer
      stripe_customer.source = stripe_token
      organization.stripe_customer_id = stripe_customer.id
      organization.out_of_band = false

      unless stripe_customer.save && organization.save
        context.fail!(message: "Unable to update billing info.")
      end
    end
  end
end
