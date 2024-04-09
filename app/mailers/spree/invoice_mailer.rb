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
        :page_size => 'Letter',
        footer: {
          right: "Order #: #{@order.number}",
          font_name: 'helvetica, verdana, serif',
          font_size: 6
        }
      )

      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else 
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    def pick_list_email(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      @order_admin_path = spree.edit_admin_order_url(@order)
      to_address = Rails.configuration.x.backoffice.to_address
      subject = "[PICK LIST] Order #: #{@order.number}"
      default_options = Rails.configuration.action_mailer.default_options
      
      attachments["pick_list-#{@order.number}.pdf"] = WickedPdf.new.pdf_from_string(
        get_pick_list_content("pick_list", @order, @order_admin_path),
        dpi: 300,
        :page_size => 'Letter',
        footer: {
          right: "Order #: #{@order.number}",
          font_name: 'helvetica, verdana, serif',
          font_size: 6
        }
      )
      
      if default_options.nil?
        mail(to: to_address, from: from_address, subject: subject)
      else
        mail(default_options.merge(to: to_address, from: from_address, subject: subject))
      end
    end

    def packing_list_email(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      to_address = Rails.configuration.x.backoffice.to_address
      subject = "[PACKING LIST] Order #: #{@order.number}"
      default_options = Rails.configuration.action_mailer.default_options
      
      attachments["packing_list-#{@order.number}.pdf"] = WickedPdf.new.pdf_from_string(
        get_packing_list_content("packing_list", @order),
        dpi: 300,
        :page_size => 'Letter',
        footer: {
          right: "Order #: #{@order.number}",
          font_name: 'helvetica, verdana, serif',
          font_size: 6
        }
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
      render_to_string(:template => "spree/invoice_mailer/invoice", formats: [:html], :layout => false)
    end

    def get_pick_list_content(template, order, order_admin_path)
      @template = template
      @order = order
      @order_admin_path = order_admin_path
      render_to_string(:template => "spree/invoice_mailer/pick_list", formats: [:html], :layout => false)
    end

    def get_packing_list_content(template, order)
      @template = template
      @order = order
      render_to_string(:template => "spree/invoice_mailer/packing_list", formats: [:html], :layout => false)
    end
  end
end
