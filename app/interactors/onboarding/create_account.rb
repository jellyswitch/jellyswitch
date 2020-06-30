class Onboarding::CreateAccount
  include Interactor::Organizer

  organize(
    Onboarding::CreateOperator,
    Onboarding::CreateAdmin
  )
end