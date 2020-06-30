class Announcements::Save
  include Interactor

  delegate :body, :user, :operator, :created_at, to: :context

  def call
    params = {
      body: body,
      user: user,
      operator: operator
    }

    if created_at.present?
      params[:created_at] = created_at
    end

    announcement = Announcement.new(params)

    if !announcement.save
      context.fail!(message: "Failed to save announcement.")
    end

    context.announcement = announcement
    context.notifiable = announcement
    context.members = true
  end
end