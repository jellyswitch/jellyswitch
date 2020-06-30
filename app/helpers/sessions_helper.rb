# typed: false
module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
    ahoy.authenticate(user)
  end

  def set_location(location)
    session[:location_id] = location.id
  end

  def unset_location
    session.delete(:location_id)
    cookies.delete(:location_id)
    @current_location = nil
  end

  # Returns the current logged-in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def current_checkin
    if !logged_in?
      nil
    else
      if current_location.present?
        current_user.checkins.for_location(current_location).open.first
      else
        nil
      end
    end
  end

  def current_location
    if !defined?(current_tenant)
      return nil
    end
    
    # this will only return nil if there is more than one location to choose and one has NOT been selected already

    # In case I"m a superadmin and my location is set to a different operator
    if session[:location_id]
      loc = Location.unscoped.find_by(id: session[:location_id])

      if loc && loc.operator != current_tenant
        unset_location
      end
    end

    # if I already have a current location set, return it
    return @current_location if @current_location

    if (location_id = session[:location_id]) # if there is a current location in the session, use it
      @current_location ||= current_tenant.locations.find_by(id: location_id)
    elsif (location_id = cookies.signed[:location_id]) # same, but for an encrypted cookie
      current_location = current_tenant.locations.find_by(id: location_id)
      if current_location
        set_location(location)
        @current_location = current_location
      else
        raise "No locations configured."
      end
    elsif Location.count == 1 # if I only have one location, use it automatically
      set_location(current_tenant.locations.first)
      @current_location = current_tenant.locations.first
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def superadmin?
    logged_in? && current_user.superadmin?
  end

  def pending?
    current_user.present? && current_user.pending?
  end

  def approved?
    current_user.present? && current_user.approved?
  end

  def hit_membership_limit?
    current_user.present? && current_user.subscriptions.active.any? do |sub|
      !sub.has_days_left?
    end
  end

  def log_out
    checkout
    forget(current_user)
    session.delete(:user_id)
    session.delete(:email)
    unset_location
    @current_user = nil
  end

  def authenticate!
    if !logged_in?
      flash[:notice] = "Please log in."
      redirect_to root_path
    end
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def checkout
    if current_checkin.present?
      result = Checkins::Checkout.call(
        checkin: current_checkin,
      )
      if !result.success?
        flash[:error] = result.message
      end
    end
  end
end
