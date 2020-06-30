# typed: true
class OperatorsController < ApplicationController
  def index
    find_operators
    authorize @production_operators

    @all_reports = @operators.all.map do |operator|
      Jellyswitch::Report.new(operator)
    end

    @production_reports = @production_operators.all.map do |operator|
      Jellyswitch::Report.new(operator)
    end

    @demo_reports = @demo_operators.all.map do |operator|
      Jellyswitch::Report.new(operator)
    end
    
    @production_staff = @production_reports.sum(&:staff_count)
    @demo_staff = @demo_reports.sum(&:staff_count)
  end

  def show
    find_operator
    authorize @operator
  end

  def new
    @operator = Operator.new
    authorize @operator
  end

  def edit
    find_operator
    authorize @operator
  end

  def create
    @operator = Operator.new(operator_params)
    authorize @operator

    if @operator.save
      flash[:success] = "Operator created."
      redirect_to operator_path(@operator)
    else
      render :new
    end
  end

  def update
    find_operator
    authorize @operator

    @operator.update_attributes(operator_params)

    if @operator.save
      flash[:success] = "Operator has been updated."
      redirect_to operator_path(@operator)
    else
      render :edit, status: 422
    end
  end

  private

  def find_operators
    @operators = Operator.order("created_at DESC").all
    @production_operators = Operator.production.order("created_at ASC").all
    @demo_operators = Operator.demo.order("created_at ASC").all
  end

  def find_operator(key = :id)
    @operator = Operator.friendly.find(params[key])
  end

  def operator_params
    params.require(:operator).permit(:name, :snippet, :wifi_name, :wifi_password, :building_address,
                                     :approval_required, :subdomain, :contact_name, :contact_email, :contact_phone,
                                     :background_image, :logo_image, :square_footage, :email_enabled, :kisi_api_key, :terms_of_service,
                                     :push_notification_certificate, :ios_url, :android_url, :checkin_required, :android_server_key)
  end
end
