# typed: false
class Operator::ReportsController < Operator::BaseController
  before_action :background_image
  before_action :generate_report, except: [:monetization]

  def index
  end

  def member_csv
    send_data @report.member_csv, filename: "Jellyswitch-Member-Data-#{short_date(Time.current)}.csv"
  end

  def active_lease_members
  end

  def active_members
  end

  def active_leases
  end

  def last_30_day_passes
  end

  def total_members
  end

  def membership_breakdown
  end

  def revenue
  end

  def checkins
  end

  def monetization
    @location = Location.find(params[:location_id])
    
    @report = Jellyswitch::MonetizationReport.new(@location)
  end

  private

  def generate_report
    @report = Jellyswitch::Report.new(current_tenant)
  end
end