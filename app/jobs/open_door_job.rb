# typed: false
class OpenDoorJob < ApplicationJob
  queue_as :default
  throttle threshold: 1, period: 5.seconds, drop: true
  include DoorsHelper

  def perform(door, user)
    response = HTTParty.post(url(door), headers: headers(door))
    DoorPunch.create!(user: user, door: door, json: response)
  rescue StandardError => e
    Rollbar.error(e.message)
  end
end
