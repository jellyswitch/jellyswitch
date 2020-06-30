class Demo::Clean::DeleteInvoices
  include Interactor

  delegate :operator, to: :context

  def call
    operator.invoices.delete_all
  end
end