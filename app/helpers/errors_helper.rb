module ErrorsHelper
  def errors_for(model)
    model.errors.full_messages.to_sentence
  end
end