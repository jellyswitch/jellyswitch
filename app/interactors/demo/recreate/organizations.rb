class Demo::Recreate::Organizations
  include Interactor

  delegate :operator, to: :context

  def call
    organization_data.each do |data|
      CreateOrganization.call(
        operator: operator,
        organization: Organization.new(
          name: data[:name],
          website: data[:website],
          owner_id: data[:owner_id]
        )
      )
    end
  end

  private

  def organization_data
    [
      {
        name: "Keep Tahoe Blue",
        website: "",
        owner_id: nil
      }
    ]
  end
end