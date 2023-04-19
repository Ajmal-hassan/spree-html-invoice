require 'barby'
require 'barby/outputter/html_outputter'
require 'barby/barcode/code_128'

module Spree
  module Admin
    class InvoiceController < Spree::BaseController
      def show
        template = params[:template]
        @template = template
        @order = Spree::Order.find_by(number: params[:id])
        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(:template => "spree/admin/invoice/#{template}", :layout => false),
          dpi: 300,
          :page_size => 'Letter',
          footer: {
            right: "Order #: #{@order.number}",
            font_name: 'helvetica, verdana, serif',
            font_size: 6
          }
        )
        send_data pdf, type: "application/pdf", filename: "#{@order.number}-#{template}.pdf", :disposition => 'attachment'
      end
    end
  end
end
