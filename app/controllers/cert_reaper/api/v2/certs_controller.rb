module CertReaper
  module Api
    module V2
      class CertsController < ::Api::V2::BaseController
        ##
        # A class to handle our puppet certificate related requests.

        # Include our puppet certificate handling mixin methods.
        include Concerns::Certifiable

        resource_description do
          resource_id 'certs'
          api_version 'v2'
          api_base_url '/cert_reaper'
        end

        api :DELETE, '/certs/:certname/', _('Clear a puppet certificate.')
        param :certname, String, :desc => 'Full name of the user', :required => true

        def destroy
          logger.warn _("DUG: @host certname is: #{params[:certname]}.")
          host_clear_cert params[:certname]

          render :json => {
            :result => _("Requested clearance of certname '#{params[:certname]}'.")
          }, :status => :ok
        end
      end
    end
  end
end
