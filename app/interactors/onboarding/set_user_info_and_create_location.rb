class Onboarding::SetUserInfoAndCreateLocation
  include Interactor::Organizer

  organize(
    Onboarding::SetUserInfo,
    Onboarding::CreateDerivedLocation,
    Onboarding::UploadLogo
  )
end