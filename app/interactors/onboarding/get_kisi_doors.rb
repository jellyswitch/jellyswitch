class Onboarding::GetKisiDoors
  include Interactor

  delegate :operator, to: :context

  def call
    url = "https://api.getkisi.com/locks/"
    headers = {
      "Accept" => "application/json",
      "Content-type" => "application/json",
      "Authorization" => "KISI-LOGIN #{operator.kisi_api_key}",
    }
    context.doors = HTTParty.get(url, headers: headers)
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end
