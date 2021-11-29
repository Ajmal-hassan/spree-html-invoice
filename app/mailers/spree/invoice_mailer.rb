require 'barby'
require 'barby/outputter/html_outputter'
require 'barby/barcode/code_128'

module Spree
  class InvoiceMailer < BaseMailer
    def invoice_email(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      to_address = Rails.configuration.x.backoffice.to_address
      subject = "[INVOICE] Order #: #{@order.number}"
      default_options = Rails.configuration.action_mailer.default_options

      attachments["invoice-#{@order.number}.pdf"] = WickedPdf.new.pdf_from_string(
        get_invoice_content("invoice", @order),
        dpi: 300,
        :page_size => 'Letter'
      )

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    def packaging_slip_email(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      to_address = Rails.configuration.x.backoffice.to_address
      subject = "[PACKAGING SLIP] Order #: #{@order.number}"
      default_options = Rails.configuration.action_mailer.default_options
      
      attachments["packaging_slip-#{@order.number}.pdf"] = WickedPdf.new.pdf_from_string(
        get_packaging_list_content("packaging_slip", @order),
        dpi: 300,
        :page_size => 'Letter'
      )
      
      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    private

    def get_invoice_content(template, order)
      @template = template
      @order = order
      render_to_string(:template => "spree/invoice_mailer/invoice.html.erb", :layout => false)
    end

    def get_packaging_list_content(template, order)
      @template = template
      @order = order
      render_to_string(:template => "spree/invoice_mailer/packaging_slip.html.erb", :layout => false)
    end
  end
end
