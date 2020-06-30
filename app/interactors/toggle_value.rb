class ToggleValue
  include Interactor

  delegate :object, :value, to: :context

  def call
    if object.send(value) == true
      object.update(value => false)
    else
      object.update(value => true)
    end
    context.object = object
  end
end