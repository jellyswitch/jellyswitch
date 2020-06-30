# typed: false
class ApplicationController < ActionController::Base
  layout "application"
  include ApplicationHelper
  include SessionsHelper
  include Pagy::Backend
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "Whoops! That's not allowed. If this isn't what you were expecting, please contact #{current_location.contact_name} by calling #{current_location.contact_phone}."
    redirect_to referrer_or_root
  end

  protected

  def include_stripe
    @include_stripe = true
  end

  def referrer_or_root
    request.referrer || root_path
  end

  def turbolinks_redirect(path, action: "replace")
    @redirect_path = path

    @action = action
    flash.keep
    response.headers["Turbolinks-Location"] = path
    respond_to do |format|
      format.js do
        render "shared/turbolinks_redirect.js.erb"
      end
      format.html do
        redirect_to path
      end
    end
  end
end
