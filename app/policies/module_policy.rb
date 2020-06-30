# typed: true
class ModulePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def announcements?
    admin?
  end

  def bulletin_board?
    admin?
  end
  
  def events?
    admin?
  end

  def door_integration?
    admin?
  end

  def rooms?
    admin?
  end

  def offices?
    admin?
  end

  def credits?
    admin?
  end

  def crm?
    admin?
  end

  def childcare?
    admin?
  end
  
  def reservation_credits_settings?
    admin? && credits?
  end

  def childcare_reservations_settings?
    admin? && childcare?
  end
end
