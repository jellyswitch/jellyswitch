# typed: false
Rails.application.config.session_store(
  :cookie_store,
  key: '_magic_session',
  domain: :all,
  secure: Rails.env.production?,
  http_only: true, # to keep JS from accessing the cookies,
  expire_after: 1.year
)