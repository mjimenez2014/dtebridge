class Api::V1::NotificationController < Api::V1::ApiController
   def index
   	
   end
  def send_notif
    puts "======== ENVIO EMAIL =========="
    NotificationMailer.notification_emails("jimenezmaury@gmail.com").deliver
    render "/api/v1/iat/ping" 
  end

end
