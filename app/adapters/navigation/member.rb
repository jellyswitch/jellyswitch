class Navigation::Member < Navigation::Default
  def web
    "layouts/nav"
  end

  def paths
    member_nav_items
  end

  def tab_paths
    member_tab_paths
  end
end