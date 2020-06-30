class Demo::Recreate::Announcements
  include Interactor
  include RandomTimestamps

  delegate :operator, to: :context

  def call
    messages.each do |msg|
      ::Announcements::Create.call(
        body: msg,
        user: operator.users.admins.sample,
        operator: operator,
        created_at: temp_day
      )
    end
  end

  def messages
    [
      "There will be complementary donuts in the lobby today at 10am! Come and get em!",
      "Our internet has been upgraded to a 1000GBps fiber line. Enjoy, everyone!"
    ]
  end
end