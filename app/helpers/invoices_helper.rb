# typed: false
module InvoicesHelper
  def path_for_billable(invoice)
    case invoice.billable_type
    when 'User'
      user_path(invoice.billable)
    when 'Organization'
      organization_path(invoice.billable)
    end
  end
end
