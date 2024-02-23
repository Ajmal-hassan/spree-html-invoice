require 'barby'
require 'barby/outputter/html_outputter'
require 'barby/barcode/code_128'

module Spree
  module Admin
    module ReturnAuthorizationsControllerDecorator

      def self.prepended(base)
        base.before_action :load_form_data, only: [:new, :edit, :print]
      end

      def print
        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(:template => "spree/admin/return_authorizations/print.html.erb", :layout => false),
          dpi: 300,
          :page_size => 'Letter',
          footer: {
            right: "RA #: #{@return_authorization.number}",
            font_name: 'helvetica, verdana, serif',
            font_size: 6
          }
        )
        send_data pdf, type: "application/pdf", filename: "#{@return_authorization.number}.pdf", :disposition => 'attachment'
      end
      
    end
  end
end

::Spree::Admin::ReturnAuthorizationsController.prepend Spree::Admin::ReturnAuthorizationsControllerDecorator