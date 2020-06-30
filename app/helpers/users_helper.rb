module UsersHelper
  def user_params
    result = params.require(:user).permit(
      :name, :email, :phone, :password, :password_confirmation,
      :bio, :linkedin, :twitter, :website, :profile_photo,
      :approved, :admin, :add_member, :add_member_and_create_another,
      :always_allow_building_access
    )
    result
  end

  def find_user(key = :id)
    @user = User.friendly.find(params[key])
  end

  def find_approved_users
    @users = User.for_space(current_tenant).approved.visible.order("name")
  end

  def find_unapproved_users
    @users = User.for_space(current_tenant).unapproved.visible.order("name")
  end

  def find_archived_users
    @users = User.for_space(current_tenant).archived.order("name")
  end

  def approval_redirect_path
    if params[:feed_item]
      feed_item = FeedItem.find params[:feed_item]
      feed_item_path(feed_item)
    else
      user_path(@user)
    end
  end
end