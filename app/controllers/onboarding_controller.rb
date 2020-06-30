class  OnboardingController < ApplicationController
  def new_user
  end

  def create_user
    result = Onboarding::CreateAccount.call(
      email: params[:email]
    )

    if result.success?
      log_in(result.user)
      turbolinks_redirect(new_user_info_onboarding_index_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(new_user_onboarding_index_path, action: "replace")
    end
  end

  def new_user_info
    @user = current_user
  end

  def create_user_and_locations
    result = Onboarding::SetUserInfoAndCreateLocation.call(
      user: current_user,
      name: params[:name],
      password: params[:password],
      phone: params[:phone],
      operator_name: params[:operator_name],
      logo: params[:logo_image]
    )

    if result.success?
      set_location(result.location)
      turbolinks_redirect(choose_events_onboarding_index_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(new_user_info_onboarding_index_path, action: "replace")
    end
  end

  def choose_events
  end

  def add_event
  end

  def create_event
    result = ::Events::Create.call(
      location: current_user.operator.locations.first,
      user: current_user,
      event_params: {
        title: params[:event_name],
        description: params[:event_description],
        starts_at: (Time.current + 1.day).strftime("%m/%d/%Y %l:%M %p")
      }
    )

    if result.success?
      result.event.image.attach(io: image = File.open(Rails.root.join("app/assets/images/coffee.jpg")), filename: "coffee.jpg")
      turbolinks_redirect(daily_tasks_onboarding_index_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(add_event_onboarding_index_path, action: "replace")
    end
  end

  def daily_tasks
    @tasks = possible_tasks
  end

  def create_daily_tasks
    possible_tasks.each do |task|
      key = task.first
      if params[key].to_i == 1
        FeedItems::Create.call(
          blob: { text: task[1], type: "post" },
          user: current_user,
          operator: current_user.operator,
          photos: []
        )
      end
    end

    turbolinks_redirect(favorite_parts_onboarding_index_path, action: "replace")
  end

  def favorite_parts
    @favorite_parts = possible_favorite_parts
  end

  def create_favorite_parts
    comment = possible_favorite_parts.select { |p| p.first == params[:favorite_part].to_sym }.first.last
    result = MemberFeedback::Create.call(
      member_feedback_params: {
        anonymous: true,
        comment: "I love #{comment.downcase}!",
        user_id: current_user.id
      }, 
      user: current_user, 
      operator: current_user.operator
    )

    turbolinks_redirect(finalize_onboarding_index_path, action: "replace")
  end

  def finalize
  end
  
  private
  
  def possible_tasks
    [
      [:lights_music, "Turned on the lights and started music in the common area", "Turn on the lights and select music for the common area"],
      [:run_dishwasher, "Ran the dishwasher", "Run the dishwasher"],
      [:take_out_trash, "Took the trash out", "Take out the trash"],
      [:restock_snacks, "Restocked the snacks and beverages in the fridge", "Restock snacks and drinks"],
      [:make_coffee, "Made a fresh pot of coffee", "Make a fresh pot of coffee"],
      [:give_tour, "Gave a tour", "Give a tour"],
      [:deliver_packages, "Delivered a package to member", "Deliver packages"],
      [:pay_bills, "Paid all bills", "Pay the bills"],
      [:adjust_heater, "Adjusted the thermostat, it was too cold", "Adjust the heater / AC"]
    ]
  end

  def possible_favorite_parts
    [
      [:interior_design, "The design of the space"],
      [:community, "The sense of community"],
      [:amenities, "The amenities"],
      [:impact, "The impact on the local economy"],
      [:events, "The popular events"]
    ]
  end
end