class Onboarding::UploadBackgroundImage
  include Interactor
  include ErrorsHelper

  delegate :location, :background, to: :context

  def call
    location.update_attributes(background_image: background)

    unless location.save
      context.fail!(message: errors_for(location))
    end
  end

  def rollback
    location.background_image.purge
  end
end