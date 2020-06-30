class Demo::Recreate::Admins
  include Interactor
  include ErrorsHelper

  delegate :operator, to: :context

  def call
    names.each do |name|

      user = operator.users.find_by(name: name)
      user.update(admin: true)
    end
  end

  private

  def names
    [
      "Alix Conyer",
      "Brent Stellar"
    ]
  end
end