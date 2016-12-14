module CertReaper

  # Example: Plugin's HostsController inherits from Foreman's HostsController
  extend ProxyAPI

  class HostsController < ::HostsController
    # change layout if needed
    # layout 'cert_reaper/layouts/new_layout'

    def new_action

    end

    private
    def multiple_clear_cert
      @hosts.each do |host|
        logger.warn _("DUG: Deleting certificate #{@host.certname}.")
      end
      notice _('Multiple certificates cleared')
      redirect_back_or_to hosts_path
    end

    def clear_cert
      @cert_name = @host
      # automatically renders view/cert_reaper/hosts/clear_action

      @host = Host.find_by_name(params[:id])

      logger.warn _("Successfully executed, you rock")
      logger.warn _(SmartProxy.inspect)
      logger.warn _(@host.inspect);
      logger.warn _(SETTINGS.inspect);

      logger.warn _("DUG: Deleting certificate #{@host.certname}.")
      api = ProxyAPI::Puppetca.new({:url => @host.puppet_ca_proxy.url})
      api.del_certificate(@host.certname)
      logger.warn _("DUG: Deleted certificate #{@host.certname}.")
      
      logger.warn _(local_variables)
      logger.warn _(instance_variables)
      logger.warn _(global_variables)

      
      # logger.warn _(HostsController.public_instance_methods)
      # logger.warn _(self.public_methods)
      # logger.warn _(self.singleton_methods)
      # File.open('/tmp/dug.oot', 'w') {
      #   |file| file.write("clear_cert was called")
      # }
    end

  end
end
