# typed: false
module OrganizationHelper
  def add_member_options(organization)
    current_tenant.users.not_in_organization(organization).order(name: :asc).map do |user|
      ["#{user.name} (#{user.email})", user.id]
    end
  end
end
