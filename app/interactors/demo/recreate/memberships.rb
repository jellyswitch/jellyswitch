class Demo::Recreate::Memberships
  include Interactor
  include ErrorsHelper
  include RandomTimestamps

  delegate :operator, to: :context

  def call
    # for each batch of 10 members
    # subtract a week
    # enroll them into plans

    operator.users.find_in_batches(batch_size: 10) do |group|
      if group.count < 10
        group.each do |user|
          subscribe(user, part_time)
        end
      else
        # 2 dedicated desk
        group[0..1].each do |user|
          subscribe(user, dedicated_desk)      
        end
        group[2..3].each do |user|
          subscribe(user, part_time)
        end
        group[4..5].each do |user|
          subscribe(user, full_time)
        end
      end
    end
  end

  private

  def subscribe(user, plan)
    subscription = Subscription.new(
      plan_id: plan.id,
      created_at: temp_day
    )
    
    subscription.active = true
    subscription.subscribable = user

    result = Billing::Subscription::CreateSubscription.call(
      subscription: subscription,
      token: nil,
      user: user,
      start_day: Time.current + 2.hours,
      out_of_band: true,
    operator: operator
    )

    if !result.success?
      context.fail!(message: result.message)
    end
  end

  def dedicated_desk
    @dedicated_desk ||= operator.plans.find_by(name: "Dedicated Desk")
  end

  def part_time
    @part_time ||= operator.plans.find_by(name: "Part Time Membership")
  end

  def full_time
    @full_time ||= operator.plans.find_by(name: "Full Time Membership")
  end
end