class JellyswitchMail < MailHatch
  include ActionView::Helpers::TextHelper
  attr_reader :operator

  def initialize(operator, dry_run: false)
    @operator = operator
    super(
      api_key: ENV['MAILHATCH_API_KEY'],
      brand_color: "#ff9900", 
      debug: true,
      dry_run: dry_run,
      sendgrid_api_key: ENV['SENDGRID_API_KEY'],
      ios_store_url: operator.ios_url,
      google_play_store_url: operator.android_url,
      title: operator.name,
      address: operator.building_address
    )
  end

  def announcement(announcement, recipient)
    async_notification(
      to: "#{recipient.name} <#{recipient.email}>",
      from: "#{announcement.user.name} <#{operator.contact_email}>",
      text: announcement.body,
      subject: "Announcement from #{operator.name}"
    )
  end

  def childcare_confirmation(childcare_reservation, user)
    from_addr = user.operator.contact_email
    if from_addr.blank?
      from_addr = "noreply@jellyswitch.com"
    end

    text = """
      Hi #{user.name},
      
      This is a confirmation that you've booked childcare for #{childcare_reservation.child_profile.name}. Your reservation details are below:

      Slot: #{childcare_reservation.childcare_slot.pretty_name}
      Date: #{short_date(childcare_reservation.date)}

      Thanks, and have a great day!

      #{user.operator.contact_name},
      #{user.operator.name}
    """
  

    async_notification(
      to: "#{user.name} <#{user.email}>",
      from: from_addr,
      subject: "Childcare confirmation",
      text: simple_format(text)
    )
  end

  def onboarding(user, password)
    from_addr = user.operator.contact_email
    if from_addr.blank?
      from_addr = "noreply@jellyswitch.com"
    end

    text = """
      Hi #{user.name},
      
      Exciting news! #{user.operator.name} now has its very own smartphone app for iPhone and Android! The new app will allow you to:

      - Manage your membership
      - See all of the events happening at #{user.operator.name}
      - Book conference rooms

      We’ve already created an account for you, and transferred over all of your member information, including your membership plan. Just log in with the following credentials:

      Username: #{user.email}
      Password: #{password}

      Be sure to change your password as soon as possible!

      I hope the app gives you an even better experience at #{user.operator.name}. Please let me know if there’s anything I can do to help.

      Thanks, and have a great week!

      #{user.operator.contact_name},
      #{user.operator.name}
    """


    async_notification(
      to: "#{user.name} <#{user.email}>",
      from: from_addr,
      subject: "Welcome to #{user.operator.name}!",
      text: simple_format(text)
    )
  end

  private

  def short_date(date)
    date.strftime("%m/%d/%Y")
  end
end