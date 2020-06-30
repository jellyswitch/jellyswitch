class LeadNote < ApplicationRecord
  belongs_to :lead
  belongs_to :user

  has_rich_text :content
end
