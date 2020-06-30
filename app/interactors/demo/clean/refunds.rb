class Demo::Clean::Refunds
  include Interactor

  delegate :operator, to: :context

  def call
    operator.invoices.each do |invoice|
      invoice.refunds.destroy_all
    end
  end
end