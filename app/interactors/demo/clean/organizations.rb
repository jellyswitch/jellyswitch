class Demo::Clean::Organizations
  include Interactor

  delegate :operator, to: :context

  def call
    operator.organizations.each do |organization|
      organization.destroy
    end
  end
end