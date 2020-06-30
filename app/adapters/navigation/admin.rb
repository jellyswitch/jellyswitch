class Navigation::Admin < Navigation::Default
  def web
    "layouts/admin_nav"
  end

  def paths
    admin_nav_items
  end

  def tab_paths
    admin_tab_paths
  end
end