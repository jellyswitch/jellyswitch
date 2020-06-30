# typed: false
class Operator::AccountingController < Operator::BaseController
  def index
    background_image

    @last_month_revenue = current_tenant.invoices.last_month.sum(:amount_due)
    @last_month_square_footage = (@last_month_revenue.to_f / 100.0) / current_tenant.square_footage.to_f

    @this_month_revenue = current_tenant.invoices.this_month.sum(:amount_due)
    @this_month_square_footage = (@this_month_revenue.to_f / 100.0) / current_tenant.square_footage.to_f
  end

  def expenses
    background_image
    @expenses = FeedItem.for_operator(current_tenant).expenses.order("created_at DESC").all
  end

  def update_expenses
    @expenses = FeedItem.where("extract(month from created_at) = ? and expense = ? ", params[:month], true)
  end
end
