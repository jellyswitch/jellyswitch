class Onboarding::SetUserInfo
  include Interactor::Organizer

  organize(
    Onboarding::UpdateOperatorName,
    Onboarding::UpdateUserNameAndPassword
  )
end