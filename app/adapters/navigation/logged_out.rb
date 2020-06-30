class Navigation::LoggedOut < Navigation::Default
  def web
    "layouts/logged_out_nav"
  end

  def paths
    logged_out_nav_items
  end

  def tab_paths
    logged_out_tab_paths
  end
end