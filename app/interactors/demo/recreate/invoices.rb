class Demo::Recreate::Invoices
  include Interactor

  delegate :operator, to: :context

  def call
    # Go back 6 weeks
    (0..6).each do |week|
      week_start = Time.current.beginning_of_week - week.weeks
      
      # pick a random day
      day = week_start + Array(1..5).sample
        
      # issue an invoice
      result = Billing::Invoices::Custom::Create.call(
        billable: operator.users.members.sample,
        amount: random_amount,
        description: random_description,
        created_at: day
      )

      result.invoice.update(due_date: day)

      Billing::Invoices::MarkInvoiceAsPaid.call(invoice: result.invoice, operator: operator)
      
    end
  end

  private

  def random_amount
    Array(3500..15000).sample
  end

  def random_description
    [
      "For services rendered",
      "Multiple day passes",
      "Group memberships for last month",
      "Lots of printing!"
    ].sample
  end
end