# typed: false
module DayPassesHelper
  def pay_by_check_params
    params.permit(:out_of_band)
  end
end