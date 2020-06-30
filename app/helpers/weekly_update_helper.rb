module WeeklyUpdateHelper
  def admins_in_english(users)
    users.map do |user|
      link_to user.name, user_path(user)
    end.to_sentence
  end

  def comparison_tag(current, previous)
    "#{current} #{ up_down_arrow(current, previous) }".html_safe
  end

  def up_down_arrow(current, previous)
    color_class = ""
    arrow_class = ""

    if current > previous
      color_class = "text-success"
      arrow_class = "fas fa-arrow-up"
    elsif current < previous
      color_class = "text-danger"
      arrow_class = "fas fa-arrow-down"
    else
      color_class = ""
      arrow_class = ""
    end

    "<i class='#{arrow_class} #{color_class}'></i>"
  end
end