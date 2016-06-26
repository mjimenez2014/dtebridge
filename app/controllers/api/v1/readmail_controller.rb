# encoding: ISO-8859-1
class Api::V1::ReadMailController < Api::V1::ApiController
  def readmail
    Mail.defaults do
      retriever_method :pop3, :address => "mail.invoicedigital.cl",
      :port       => 110,
      :user_name  => 'test@invoicedigital.cl',
      :password   => 'paso2011',
      :enable_ssl => false
    end

    mails = Mail.all

    mails.each do |mail|
      doceamil = Docsemail.where(mailid: mail.message_id).first
      if !doceamil.present?

        if mail.multipart?  
          mail.attachments.each do | attachment |
            filename = attachment.filename
            extencion = filename[filename.index('.')..filename.index('.')+4]
            if extencion == ".xml"
              d = Docsemail.new
              d.xmlrecibido = attachment.body.decoded
              d.mailid = mail.message_id
              d.estado = "RECIBIDO"
              d.save
            end
          end
        end     
      end
    end   
  end
end