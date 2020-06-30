# typed: false
module EventHelpers
  def expect_event(event, params)
    expect(Jellyswitch::Events).to receive(:publish).once.with(event, params)
  end
end
