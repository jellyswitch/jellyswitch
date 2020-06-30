# typed: false
module SystemHelpers
  def start_session(name, user_session, &block)
    using_session(name) do
      yield(user_session)
    end
  end

  def new_member_session(&block)
    @user_session ||= NewUserSession.new(self)
    start_session('new member', @user_session, &block)
  end

  def admin_session(&block)
    @admin_session ||= AdminSession.new(self)
    start_session('admin session', @admin_session, &block)
  end

  class NewUserSession < SimpleDelegator
    def sign_up
      visit '/'

      find('a[data-acc="signup"]').click

      expect(page).to have_content 'Sign Up'

      within('#new_user') do
        fill_in 'Name', with: 'Jared Rader'
        fill_in 'Email', with: 'jared@rader.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirm password', with: 'password'
        find('input[data-acc="register"]').click
      end

      expect(page).to have_content 'Welcome!'
    end

    def choose_membership
      find('a[data-acc="new-member"]').click
      expect(page).to have_content 'Become a Member'
    end

    def choose_plan
      within('#stripe-form') do
        find('#subscription_plan_id option', match: :first).select_option
      end
    end

    def choose_day_pass
      find('a[data-acc="buy-day-pass"]').click
      expect(page).to have_content 'New Day Pass'
    end

    def add_card
      within('#stripe-form') do
        fill_stripe_elements('4242424242424242')
        find('input[data-acc="add-payment"]').click
      end
    end

    def fill_stripe_elements(card)
      using_wait_time(15) do
        within_frame('__privateStripeFrame10') do
          card.chars.each do |piece|
            find_field('cardnumber').send_keys(piece)
          end

          find_field('exp-date').send_keys("0122")
          find_field('cvc').send_keys '123'
          find_field('postal').send_keys '19335'
        end
      end
    end

    def select_pay_out_of_band
      within('#stripe-form') do
        find('label[for="out_of_band"]').click
        find('input[data-acc="add-payment"]').click
      end
    end

    def wait_for_approval
      expect(page).to have_content "We're excited you're here!"
    end
  end

  class AdminSession < SimpleDelegator
    def sign_in
      visit '/'

      find('a[data-acc="signin"]').click

      within('form[action="/login"]') do
        fill_in 'Email', with: admin_user.email
        fill_in 'Password', with: admin_user.password
        click_button('Sign In')
      end
    end

    def approve_member
      expect(page).to have_content 'Approve'

      find('a[data-acc="approve-member"]').click

      expect(page).to have_content 'User approved.'
    end
  end
end
