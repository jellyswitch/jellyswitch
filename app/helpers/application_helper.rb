# typed: false
module ApplicationHelper
  include ChildcareHelper
  include CreditHelper
  include ErrorsHelper
  include LandingHelper
  include LayoutHelper
  include PlansHelper
  include WeeklyUpdateHelper

  include Pagy::Frontend

  def pretty_datetime(input)
    input.strftime("%m/%d/%Y at %l:%M%P")
  end

  def short_date(date)
    date.strftime("%m/%d/%Y")
  end

  def pretty_time(time)
    time.strftime("%l:%M%P")
  end
  
  def long_date(date)
    date.strftime("%B %e, %Y")
  end

  def pretty_timestamps(a, b)
    "#{pretty_time(a)} - #{pretty_time(b)}"
  end

  def pretty_dates(a, b)
    "#{long_date(a)} - #{long_date(b)}"
  end

  def human_time_from_now(date)
    if date == Time.zone.today
      "Today"
    elsif date == Time.zone.tomorrow
      "Tomorrow"
    elsif date == Time.zone.yesterday
      "Yesterday"
    else
      date.strftime("%A")
    end
  end

  def pretty_price(office_lease)
    if office_lease.subscription.present? &&
      office_lease.subscription.plan.present?
      office_lease.subscription.plan.pretty_price
    else
      nil
    end
  end

  def google_map(center)
    key = ENV['GOOGLE_MAPS_API_KEY']
    "https://maps.googleapis.com/maps/api/staticmap?key=#{key}&markers=size:small%7Ccolor:red%7C#{center}&size=500x500&zoom=17"
  end

  def favicon(operator)
    if operator.logo_image.attached?
      url_for(operator.logo_image)
    else
      nil
    end
  end

  def stripe_oauth_url(operator, options = {})
    client_id = ENV['STRIPE_CLIENT_ID']
    redirect_uri = stripe_connect_setup_url
    stripe_landing = "login"
    if options[:stripe_landing].present?
      stripe_landing = options[:stripe_landing]
    end
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{client_id}&scope=read_write&redirect_uri=#{redirect_uri}&stripe_landing=#{stripe_landing}"
  end

  def mobile_app_request?
    ios_request? || android_request? || old_android_request?
  end

  def user_agent
    request.env['HTTP_USER_AGENT']
  end

  def has_user_agent?
    user_agent.present?
  end

  def ios_request?
    has_user_agent? && user_agent.match(/(Jellyswitch)/).present? && !old_android_request? && !android_request?
  end

  def android_request?
    has_user_agent? && user_agent.match(/(Jellyswitch\/Android\/1\.2)/).present?
  end

  def old_android_request?
    has_user_agent? && user_agent.match(/(Jellyswitch\/Android)/).present?
  end

  def days_option_for_current_month
    [*0..30].map do |i|
      day = Time.zone.now + i.days
      [long_date(day), day.to_i]
    end
  end

  def format_working_hours(location, separator="through")
    start = Time.strptime(location.working_day_start, "%R").strftime("%l:%M %P")
    ending = Time.strptime(location.working_day_end, "%R").strftime("%l:%M %P")
    "#{start} #{separator} #{ending}"
  end

  def active_working_hours?(location)
    WorkingHours::Config.with_config(working_hours: working_hours_config(location), holidays: [], time_zone: Time.zone.name) do
      Time.current.in_working_hours?
    end
  end

  def has_building_access?(user)
    user.superadmin? || 
    user.admin? || 
    user.always_allow_building_access? || 
    user.has_building_access_day_pass? || 
    user.has_building_access_membership? || 
    user.has_building_access_lease?
  end

  def boolean_to_yesno(value)
    if value
      "Yes"
    else
      "No"
    end
  end

  def quantize(collection, string)
    if collection.respond_to? :each
      count = collection.count
    else
      count = collection
    end

    if count <= 0
      string.pluralize
    elsif count == 1
      string.singularize
    else
      string.pluralize
    end
  end

  def membership_text(plan)
    if plan.operator.membership_text.present?
      "Memberships start at #{display_price(plan)} and include #{plan.operator.membership_text}."
    else
      "Memberships start at #{display_price(plan)} and vary from flexible desk space to full private offices."
    end
  end

  def working_hours_options
    [:open_sunday, :open_monday, :open_tuesday, :open_wednesday, :open_thursday, :open_friday, :open_saturday]
  end

  def no_cache
    render "layouts/no_cache"
  end

  def hourly_rate(loc)
    rate = number_to_currency(dollar_amount(loc.hourly_rate_in_cents))
    "#{rate} / hr"
  end

  def hourly_rate_room(room)
    rate = number_to_currency(dollar_amount(room.hourly_rate_in_cents))
    "#{rate} / hr"
  end

  def link_to_modal(id)
    render Bootstrap::LinkToModal, id: id do
      yield
    end
  end

  private

  def working_hours_config(location)
    config = {}

    working_hours_options.map do |day|
      if location.send("#{day}?".to_sym) == true
        config[day.to_s.split("_").last.first(3).to_sym] = {location.working_day_start => location.working_day_end}
      end
    end
    config
  end
end
