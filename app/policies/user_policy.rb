# typed: true
class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def unapproved?
    admin?
  end

  def archived?
    admin?
  end

  def show?
    owner_or_admin? 
  end

  def about?
    admin?
  end

  def childcare?
    owner_or_admin?
  end

  def credits?
    admin?
  end

  def add_credits?
    admin?
  end

  def add_childcare_reservations?
    admin?
  end

  def ltv?
    admin?
  end

  def usage?
    admin?
  end

  def payment_method?
    admin?
  end

  def membership?
    admin?
  end

  def admin_day_passes?
    admin?
  end

  def checkins?
    admin?
  end

  def organization?
    admin?
  end

  def admin_invoices?
    admin?
  end

  def new?
    true # anyone can sign up
  end

  def add_member?
    admin?
  end

  def edit?
    owner_or_admin?
  end

  def create?
    true # anyone can sign up
  end

  def update?
    owner_or_admin?
  end

  def change_password?
    owner_or_admin?
  end

  def update_password?
    owner_or_admin?
  end

  def remove_from_organization?
    admin?
  end

  def update_organization?
    admin?
  end

  def memberships?
    owner_or_admin?
  end

  def day_passes?
    owner_or_admin?
  end

  def reservations?
    owner_or_admin?
  end

  def past_reservations?
    owner_or_admin?
  end

  def invoices?
    owner_or_admin?
  end

  def approve?
    admin?
  end

  def unapprove?
    admin?
  end

  def edit_billing?
    owner_or_admin?
  end

  def update_billing?
    owner_or_admin?
  end

  def set_password_and_send_email?
    admin?
  end

  def archive?
    admin?
  end

  def unarchive?
    admin?
  end

  private

  def owner_or_admin?
    # Needed because the record itself is the user
    admin? || (is_user? && user == record)
  end
end