# typed: false
class RoomDecorator < ApplicationDecorator
  delegate_all
  decorates_association :reservations
  decorates_finders

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def smart_link
    if policy(object).show?
      link_to(object.name, room_path(object))
    else
      object.name
    end
  end

  def smart_photo
    if object.has_photo?
      image_tag(room.card_photo, class: "img-thumbnail", style: "height: 200px;")
    else
      image_tag("profile-125x125.jpg", class: "img-thumbnail", style: "height: 200px;")
    end
  end
end
