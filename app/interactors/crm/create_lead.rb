class Crm::CreateLead
  include Interactor

  delegate :user, :visit, :operator, to: :context

  def call
    if operator.crm_enabled?
      lead = operator.leads.new
      lead.user = user
      lead.ahoy_visit = visit
      lead.source = Lead::SOURCES[:event]

      if !lead.save
        context.fail!(message: "Could not create lead.")
      end

      context.lead = lead
    end
  end
end