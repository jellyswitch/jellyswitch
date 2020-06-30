# typed: false
# == Schema Information
#
# Table name: invoices
#
#  id                :bigint(8)        not null, primary key
#  amount_due        :integer
#  amount_paid       :integer
#  billable_type     :string
#  date              :datetime
#  due_date          :datetime
#  number            :string
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  billable_id       :bigint(8)
#  operator_id       :integer
#  stripe_invoice_id :string
#
# Indexes
#
#  index_invoices_on_billable_type_and_billable_id  (billable_type,billable_id)
#

class Invoice < ApplicationRecord
  belongs_to :operator
  acts_as_tenant :operator

  belongs_to :billable, polymorphic: true
  has_many :checkins
  has_many :refunds

  scope :recent, -> { where('date > ?', Time.now - 30.days) }
  scope :open, -> { where("status = 'open'") }
  scope :due, -> { open.where('due_date >= ?', Time.now) }
  scope :paid, ->{ where(status: "paid") }
  scope :delinquent, -> { open.where('due_date < ?', Time.now) }
  scope :groups, -> { where(billable_type: "Organization") }
  scope :last_month, -> {
    last_month_start = (Time.now.beginning_of_month - 1.day).beginning_of_month.to_time.to_i
    this_month_start = Time.now.beginning_of_month.to_time.to_i

    where("date >= to_timestamp(?) AND date < to_timestamp(?)", last_month_start, this_month_start)
  }
  scope :this_month, -> {
    this_month_start = Time.now.beginning_of_month.to_time.to_i

    where("date >= to_timestamp(?)", this_month_start)
  }
  scope :for_week, -> (week_start, week_end) { where('due_date > ? and due_date <= ?', week_start, week_end) }

  VOIDABLE_STATUSES = %w(open uncollectible)
  STATUSES = (VOIDABLE_STATUSES + %w(void paid refunded)).freeze

  STATUSES.each do |invoice_status|
    define_method("#{invoice_status}?") do
      status == invoice_status
    end
  end

  def stripe_invoice
    if stripe_invoice_id.present?
      @stripe_invoice ||= Stripe::Invoice.retrieve(stripe_invoice_id, {
        api_key: operator.stripe_secret_key,
        stripe_account: operator.stripe_user_id
      })
    else
      nil
    end
  end

  def pdf_url
    if stripe_invoice_id.present? && !void?
      stripe_invoice.invoice_pdf
    else
      nil
    end
  end

  def pretty_due_date
    if due_date.nil?
      nil
    else
      due_date.strftime("%m/%d/%Y")
    end
  end

  def pretty_date
    date&.strftime("%m/%d/%Y %l:%M%P")
  end

  def voidable?
    VOIDABLE_STATUSES.include?(status)
  end

  def refunded?
    refunds.length > 0
  end

  def paid?
    status == "paid"
  end

  def payment_method
    if stripe_invoice
      stripe_invoice.billing == "charge_automatically" ? "Credit Card" : "Cash or check"
    else
      "error"
    end
  end

  def description
    stripe_invoice.lines.data.map(&:description).join("\n")
  end
end
