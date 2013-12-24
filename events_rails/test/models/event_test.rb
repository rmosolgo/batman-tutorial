require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "name must be unique" do
    event_1 = Event.new(name: "great event!")
    event_1.save!
    event_2 = Event.new(name: event_1.name)
    assert event_2.valid? == false
  end

  test "ends_at must be greater than starts_at" do
    event = Event.new(starts_at: Time.now + 1.day, ends_at: Time.now)
    assert event.starts_at > event.ends_at
    assert event.valid? == false, "Should be invalid"
  end
end
