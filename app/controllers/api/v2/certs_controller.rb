module Api
  module V2
    class CertsController < ::Api::V2::BaseController

      resource_description do
        resource_id 'certs'
        api_version 'v2'
        api_base_url '/api'
      end

      api :DELETE, '/certs/:certname/', _('Clear a puppet certificate.')
      param :certname, :required => true, String, desc: 'Full name of the user'

      def destroy
        render :json => { :error => _('Destroy got called with "#{params['certname']}".' }, :status => :precondition_failed
      end
    end
  end
end
