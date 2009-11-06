class Emailer < ActionMailer::Base

      def contact_email(email_params, sent_at = Time.now)
        # You only need to customize @recipients.
        name = email_params[:name]
        @from = email_params[:mail]
        @recipients = "ventas@skykidsperu.com"
        # @recipients = "alvaro.pereyra@srdperu.com"
        @subject = "[SKYKIDSWEB] Consulta de #{name} <#{email_params[:mail]}>"
        @sent_on = sent_at
        @body["email_body"] = email_params[:message]
        @body["email_name"] = name
        @body["email_mail"] = email_params[:mail]
        @body["email_address"] = email_params[:address]
        @body["email_business"] = email_params[:business]
      end
      
      def quote_mail(quote, sent_at = Time.now)
        @content_type = "text/html"
        recipients quote.sending_details + ", control@skykidsperu.com"
        @from = "ventas@skykidsperu.com"
        @subject = "Re: [Skykids Perú 2009] Cotización 2009 "
        @sent_on = sent_at
        @body["contact_name"] = quote.contact_name
        @body["from_web"] = quote.from_web
        @body["email_link"] = 
"http://www.skykidsperu.com/web/cotizaciones/" + Base64.encode64(quote.sending_details).gsub!("\n","")
      end 

      def client_email(client)
        @content_type = "text/html"
        recipients client.contact_email + ", control@skykidsperu.com"
        @from = "ventas@skykidsperu.com"
        @subject = "[Skykids Perú] - Invitación a nuestro Showroom 2009"
        @body["contact_name"] = client.contact_person
        @body["name"] = client.name
      end

end
