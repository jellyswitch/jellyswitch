task backfill_invoices: :environment do
  Operator.all.each do |operator|
    BackfillInvoices.call(operator: operator)
  end
end