class Demo::Recreate::CreateMembers
  include Interactor
  include ErrorsHelper

  delegate :operator, to: :context

  def call
    people_data.each do |data|
      result = Users::Create.call(
        operator: operator,
        params: {
          name: data[:name],
          email: data[:email],
          password: data[:password],
          password_confirmation: data[:password]
        }
      )

      if result.success?
        result.user.profile_photo.attach(io: File.open(Rails.root.join("app/assets/images/demo/people/#{data[:profile_photo_path]}")), filename: data[:profile_photo_path])
        result.user.update(
          approved: data[:approved],
          out_of_band: true
        )
      else
        context.fail!(message: result.message + errors_for(result.user))
      end
    end
  end

  private

  def people_data
    files = Dir[Rails.root.join("app/assets/images/demo/people/*")].map{|s| s.split("/").last }
    files.map do |f|
      name = f.split(".").first
      email = name.split(" ").join(".")

      {
        name: name,
        email: "#{email}@jellyswitch.com",
        password: "password123",
        profile_photo_path: f,
        approved: true
      }
    end
  end
end