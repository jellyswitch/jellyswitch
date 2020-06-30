# typed: false
module HostValidator
  def validate_host
    raise "No @operator defined" unless @operator.present?
  end

  protected

  def default_url_options
    {
      host: "#{@operator.subdomain}.#{ENV['HOST']}"
    }
  end

  def mail(headers = {}, &block)
    validate_host
    if @operator.email_enabled?
      super(headers.merge(default_options), &block)
    else
      false
    end
  end

  def default_options
    {
      from: "#{@operator.name} <noreply@#{@operator.subdomain}.#{ENV['HOST']}>"
    }
  end
end