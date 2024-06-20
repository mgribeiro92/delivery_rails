class PaymentJob < ApplicationJob
  queue_as :default

  def perform(order:, value:, number:, valid:, cvv:)
    params = { payment: {value: value, number: number, valid: valid, cvv: cvv} }
    response = con.post("/payments", params.to_json)
    @order = Order.find(order)
    @order.payment_success! if response.success?

  end

  private

  def config
    host = ENV['PAYMENT_URL'] || Rails.configuration.payment.host
    Rails.configuration.payment.merge(host: host)
  end

  def con
    @con ||= Faraday.new(
      url: config.host,
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
      }
    )
  end


end
