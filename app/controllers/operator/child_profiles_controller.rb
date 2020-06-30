class Operator::ChildProfilesController < Operator::BaseController
  before_action :background_image

  def index
    find_child_profiles
    authorize @child_profiles
  end

  def new
    @child_profile = current_user.child_profiles.new
    authorize @child_profile
  end

  def create
    @child_profile = current_user.child_profiles.new(child_profile_params)
    authorize @child_profile

    if @child_profile.save
      flash[:success] = "Profile added."
      turbolinks_redirect(child_profile_path(@child_profile), action: "replace")
    else
      flash[:error] = "Something went wrong."
      turbolinks_redirect(new_child_profile_path, action: "replace")
    end
  end

  def edit
    find_child_profile
    authorize @child_profile
  end

  def update
    find_child_profile
    authorize @child_profile

    if @child_profile.update(child_profile_params)
      flash[:success] = "Profile updated."
      turbolinks_redirect(child_profile_path(@child_profile), action: "replace")
    else
      flash[:error] = "Something went wrong."
      turbolinks_redirect(child_profile_path(@child_profile), action: "replace")
    end
  end

  def show
    find_child_profile
    authorize @child_profile
  end

  private

  def find_child_profiles
    if admin?
      @child_profiles = current_tenant.child_profiles
    else
      @child_profiles = current_user.child_profiles
    end
  end

  def find_child_profile(key=:id)
    if admin?
      @child_profile = current_tenant.child_profiles.find(params[key])
    else
      @child_profile = current_user.child_profiles.find(params[key])
    end
  end

  def child_profile_params
    params.require(:child_profile).permit(:name, :birthday, :notes, :photo)
  end
end