# typed: false
class AddLocationAndResourcesForSpaces < ActiveRecord::Migration[5.2]
  LOCATION_RESOURCES = %w(rooms offices office_leases doors)

  def up
    FeedItem.all.select do |feed_item|
      feed_item.user.blank?
    end.map(&:destroy)

    LOCATION_RESOURCES.each do |resource|
      add_reference :"#{resource}", :location, foreign_key: true
      resource.singularize.camelize.constantize.reset_column_information
    end

    Operator.all.each do |operator|
      puts "Creating location and location resources for #{operator.name} (ID: #{operator.id})"
      location = operator.locations.create!(
        operator.attributes.except(*%w(
          id
          android_url
          approval_required
          day_pass_cost_in_cents
          email_enabled
          ios_url
          kisi_api_key
          subdomain
          created_at
          updated_at
          stripe_user_id
        )
      ))

      LOCATION_RESOURCES.each do |resource|
        operator.public_send(resource).each do |model|
          model.location_id = location.id
          model.save!
        end
      end
    end
  end

  def down
    LOCATION_RESOURCES.each do |resource|
      remove_reference :"#{resource}", :location, foreign_key: true
    end
    Location.delete_all
  end
end
