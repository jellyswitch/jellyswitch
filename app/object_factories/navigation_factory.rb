class NavigationFactory
  def self.for(logged_in, admin, current_tenant, current_location, current_user)
    if logged_in
      if admin
        Navigation::Admin
      else
        Navigation::Member
      end
    else
      Navigation::LoggedOut
    end.new(current_tenant, current_location, current_user)
  end
end