class Onboarding::UploadLogo
  include Interactor
  include ErrorsHelper

  delegate :location, :logo, to: :context

  def call
    operator = location.operator
    operator.update_attributes(
      logo_image: logo
    )
    
    unless operator.save
      context.fail!(message: errors_for(operator))
    end
  end

  def rollback
    location.operator.logo_image.purge
  end
end