module FeedItemsHelper
  private

  def new_feed_item
    @feed_item = FeedItem.new
  end

  def find_feed_items
    @pagy, @feed_items = pagy(FeedItem.unscoped.for_operator(current_tenant).order("updated_at DESC"))
  end

  def find_questions
    @pagy, @feed_items = pagy(FeedItem.unscoped.questions.for_operator(current_tenant).order("updated_at DESC"))
  end

  def find_activity
    @pagy, @feed_items = pagy(FeedItem.unscoped.activity.for_operator(current_tenant).order("updated_at DESC"))
  end 

  def find_notes
    @pagy, @feed_items = pagy(FeedItem.unscoped.notes.for_operator(current_tenant).order("updated_at DESC"))
  end

  def find_financial
    @pagy, @feed_items = pagy(FeedItem.unscoped.financial.for_operator(current_tenant).order("updated_at DESC"))
  end

  def feed_item_params
    params.require(:feed_item).permit(:text, photos: [])
  end

  def find_feed_item(key = :id)
    @feed_item = FeedItem.unscoped.find(params[key])
  end

  def turn_into_expense
    @feed_item.parse_amount
    @feed_item.set_expense
    @feed_item.save
  end

  def not_an_expense
    @feed_item.unset_expense
    @feed_item.save
  end

  def find_room_reservations
    @reservations = current_location.rooms.map do |room|
      room.reservations.today
    end.flatten.uniq.count
  end

  def find_upcoming_renewals
    @upcoming_renewals = current_tenant.offices.upcoming_renewals(60)
  end

  def find_upcoming_childcare_reservations
    @upcoming_childcare_reservations = current_tenant.childcare_reservations.upcoming.all
  end

  def find_delinquent_invoices
    @delinquent_invoices = current_tenant.invoices.delinquent.order('date DESC')
    @delinquent_amount = @delinquent_invoices.sum(:amount_due) / 100.0
  end
end