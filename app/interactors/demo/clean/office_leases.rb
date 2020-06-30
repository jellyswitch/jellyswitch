class Demo::Clean::OfficeLeases
  include Interactor

  delegate :operator, to: :context

  def call
    operator.office_leases.each do |office_lease|
      office_lease.delete
    end
  end
end