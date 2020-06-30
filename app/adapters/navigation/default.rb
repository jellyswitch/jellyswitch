class Navigation::Default < SimpleDelegator
  include Rails.application.routes.url_helpers
  include Pundit
  attr_reader :operator, :location, :user

  def initialize(operator, location, user)
    @operator = operator
    @location = location
    @user = user
  end

  def ios
    "layouts/ios_nav"
  end

  def android
    "layouts/android_nav"
  end

  def admin_nav_items
    items = []

    items << {title: "Home", path: feed_items_path}

    if policy(:door).enabled?
      items << {title: "Building Access", path: doors_path}
    end

    if policy(:announcement).enabled?
      items << {title: "Announcements", path: announcements_path}
    end

    if policy(:post).enabled?
      items << {title: "Bulletin Board", path: posts_path}
    end

    if policy(:event).enabled?
      items << {title: "Events", path: events_path}
    end

    items << {title: "Members & Groups", path: members_groups_path}

    if policy(:office).enabled?
      items << {title: "Offices & Leases", path: offices_path}
    end
    
    if policy(:room).enabled?
      items << {title: "Rooms & Reservations", path: rooms_path}
    end

    if policy(:lead).enabled?
      items << {title: "Leads", path: leads_path}
    end

    if policy(:payment).enabled?
      [
        {title: "Plans & Day Passes", path: plans_day_passes_path},
        {title: "Invoices & Expenses", path: accounting_index_path}
      ].each do |item|
        items << item
      end
    end

    if policy(:childcare).enabled?
      items << {title: "Childcare", path: childcare_index_path}
    end

    [
      {title: "Data", path: reports_path},
      {title: "Customization", path: customization_path},
      {title: "My Account", path: user_path(user)},
      {title: "Member Dashboard", path: home_path}
    ].each do |item|
      items << item
    end

    if operator.locations.count > 1
      items = items.insert(
        4,
        {title: "Change Location", path: edit_set_location_path}
      )
    end

    if user.superadmin?
      items << {title: "App Config", path: app_configs_path}
    end
    items
  end

  def member_nav_items
    items = [
      {title: "Home", path: root_path}
    ]

    if policy(:post).enabled?
      items << {title: "Bulletin Board", path: posts_path}
    end

    if policy(:event).enabled?
      items << {title: "Events", path: events_path}
    end
    
    if user.allowed_in?(location) && user.approved?
      if policy(:room).enabled? && location.rooms.visible.count > 0
        items << {title: "Reserve a room", path: rooms_path}
      end

      if policy(:door).enabled? && location.doors.count > 0
        items << {title: "Building Access", path: keys_doors_path}
      end
    end

    if policy(:childcare).enabled?
      items << {title: "Childcare", path: childcare_index_path}
    end
    
    items << {title: "My Account", path: user_path(user)}

    if operator.locations.count > 1
      items = items << {title: "Change Location", path: edit_set_location_path}
    end

    items
  end

  def logged_out_nav_items
    items = []
    if @location.present?
      items << {title: "Sign Up", path: signup_path}
      items << {title: "Sign In", path: login_path}
    end

    if operator.locations.count > 1
      items = items << {title: "Change Location", path: edit_set_location_path}
    end

    items
  end

  def admin_tab_paths
    [
      {title: "Home", path: feed_items_path},
      {title: "Search", path: new_search_result_path}
    ]
  end

  def member_tab_paths
    items = [
      {title: "Home", path: home_path}
    ]

    if policy(:door).enabled? && location.doors.count > 0
      items << {title: "Building Access", path: keys_doors_path}
    end

    if policy(:room).enabled? && location.rooms.visible.count > 0
      items << {title: "Reserve a room", path: rooms_path}
    end

    items << {title: "My Account", path: user_path(user)}
    items
  end

  def logged_out_tab_paths
    [
      {title: "Sign Up", path: signup_path},
      {title: "Sign In", path: login_path}
    ]
  end

  def pundit_user
    UserContext.new(user, operator, location)
  end
end