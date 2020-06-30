module Permissions
  # Included as a module in the User class

  def allowed_in?(location)
    member?(location) || 
    has_active_day_pass? || 
    checked_in?(location) || 
    has_active_lease? || 
    admin? || 
    has_reservation? || 
    has_rsvp?
  end

  def has_reservation?
    reservations.any? do |reservation|
      reservation.datetime_in.day == Time.current.day
    end
  end

  def should_charge_for_reservation?(location)
    if operator.production? || operator.subdomain == "southlakecoworking"
      !(member?(location) || has_active_day_pass? || has_active_lease? || admin?)
    else
      false
    end
  end

  def can_see_all_rooms?(location)
    if operator.production? || operator.subdomain == "southlakecoworking"
      member?(location) ||
      has_active_day_pass? ||
      checked_in?(location) ||
      has_active_lease? ||
      admin?
    else
      true
    end
  end

  def has_rsvp?
    rsvps.going.today.count > 0
  end

  def member_at_operator?(operator, day = Time.current)
    has_active_subscription? || has_active_day_pass?(day=day) || has_active_lease?
  end

  def member?(location, day = Time.current)
    has_active_subscription_at_location?(location)
  end

  def has_active_subscription_at_location?(location)
    subscriptions.for_location(location).active.select do |sub|
      sub.has_days_left?
    end.count > 0
  end

  def admin?
    admin
  end

  def superadmin?
    superadmin
  end

  def pending?
    subscriptions.pending.count > 0
  end

  def has_active_subscription?
    subscriptions.for_operator(operator).active.select do |sub|
      sub.has_days_left?
    end.count > 0
  end

  def has_building_access_membership?
    has_active_subscription? && subscriptions.active.any? do |subscription|
      subscription.plan.always_allow_building_access?
    end
  end

  def has_active_day_pass?(day = Time.current)
    day_passes.for_day(day).count > 0
  end

  def has_building_access_day_pass?
    has_active_day_pass? && day_passes.today.any? do |day_pass|
      day_pass.day_pass_type.always_allow_building_access?
    end
  end

  def has_active_lease?
    organization.present? && organization.has_active_lease?
  end

  def has_building_access_lease?
    has_active_lease? && organization.active_leases.any? do |lease|
      lease.always_allow_building_access?
    end
  end

  def organization_owner?
    owned_organization.present?
  end

  def visible?
    !archived?
  end

  def member_of_organization?
    organization.present?
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def has_profile_photo?
    profile_photo.attached?
  end

  def checked_in?(location)
    checkins.for_location(location).open.count > 0
  end
end