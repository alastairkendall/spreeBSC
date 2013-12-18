Spree::OrderMailer.class_eval do
  
  def bsc_order_email(order, resend = false)
#debugger
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Config[:site_name]} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
    #mail(to: @order.email, from: from_address, subject: subject)
    mail(to: Spree::Config[:curtain_maker_email], from: from_address, subject: subject)
  end

end