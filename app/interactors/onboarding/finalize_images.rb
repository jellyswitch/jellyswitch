class Onboarding::FinalizeImages
  include Interactor::Organizer

  organize(
    Onboarding::UploadLogo,
    Onboarding::UploadBackgroundImage
  )
end