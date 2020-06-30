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

FactoryBot.define do
  factory :invoice do
    amount_due { rand(10_000) }
    amount_paid { rand(10_000) }
    date { Date.today.beginning_of_week }
    due_date { 1.month.from_now.beginning_of_month }
    sequence(:number) { |n| "14F29C43-00#{n}" }
    sequence(:stripe_invoice_id) { |n| "in_1EMkzyFwWCUYnLp4d8Td#{n}aDH" }
    status { 'open' }

    trait :with_user do
      before(:create) do |invoice|
        operator = create(:operator, :with_users)
        invoice.operator = operator
        invoice.billable = operator.users.first
      end
    end

    trait :with_organization do
      before(:create) do |invoice|
        operator = create(:operator, :with_organizations)
        invoice.operator = operator
        invoice.billable = operator.organizations.first
      end
    end

    trait :for_user do
      association :billable, factory: :user
    end

    trait :for_organization do
      association :billable, factory: :organization
    end

    trait :voidable do
      status { Invoice::VOIDABLE_STATUSES.sample }
    end

    trait :paid do
      status { 'paid' }
      amount_paid { amount_due }
    end

    trait :void do
      status { 'void' }
    end

    trait :refunded do
      status { 'refunded' }
    end
  end
end
