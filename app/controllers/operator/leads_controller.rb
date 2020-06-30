class Operator::LeadsController < Operator::BaseController
  include LeadsHelper
  before_action :background_image
  
  def index
    find_leads
    authorize @leads
  end

  def show
    find_lead
    authorize @lead
  end

  def edit
    find_lead
    authorize @lead
  end

  def update
    find_lead
    authorize @lead

    if !@lead.update(lead_params)
      flash[:error]= "Something went wrong."
    end
    turbolinks_redirect(lead_path(@lead), action: "replace")
  end
end