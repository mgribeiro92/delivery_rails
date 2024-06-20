class NotificationChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Subscribed to channel: #{params.inspect}"
    if params[:type] == 'user'
      stream_from "notification_user_#{params[:id]}"
    elsif params[:type] == 'store'
      stream_from "notification_store_#{params[:id]}"
    else
      reject
    end
  end

  # def receive(data)
  #   Rails.logger.info "NotificationChannel#receive called with data: #{data.inspect}"
  #   transmit(notification: "Mensagem recebida: #{data['message']}")
  # end

  def unsubscribed
    # Cleanup when the channel is unsubscribed
  end
end
