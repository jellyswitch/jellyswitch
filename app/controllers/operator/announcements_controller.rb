class Operator::AnnouncementsController < Operator::BaseController
  include AnnouncementHelper
  before_action :background_image

  def index
    find_announcements
    authorize @announcements
  end

  def new
    @announcement = Announcement.new
    authorize @announcement
  end

  def create
    authorize Announcement.new

    result = Announcements::Create.call(
      body: announcement_params[:body],
      user: current_user,
      operator: current_tenant
    )
    
    if result.success?
      flash[:success] = "Announcement posted."
      turbolinks_redirect(announcements_path, action: "restore")
    else
      flash[:error] = result.message
      turbolinks_redirect(new_announcement_path, action: "restore")
    end
  end
end