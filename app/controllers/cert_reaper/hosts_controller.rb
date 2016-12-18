module CertReaper
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  extend ProxyAPI

  class HostsController < ::HostsController
    # change layout if needed
    # layout 'cert_reaper/layouts/new_layout'
    before_action :find_resource, :only => [:clear_cert]

    def clear_cert
      # Since I don't trust the @hosts instance variable to always be
      # set correctly. I'll assume we are always dealing with params[:id]
      # and even this seems to sometimes be a hostname string and other times be
      # a host instance and there's also a params[:host_id] and a params[:id]
      # in the code.
      #
      # automatically renders view/cert_reaper/hosts/clear_action
      logger.warn _("DUG: params is: #{params.inspect}.")
      logger.warn _("DUG: class of params[:id] is: #{params[:id].class}.")
      logger.warn _("DUG: inspect of params[:id] is: #{params[:id].inspect}.")
      logger.warn _("DUG: Smart Proxy is #{SmartProxy.inspect}")
      logger.warn _("DUG: Foreman settings we know are: #{SETTINGS.inspect}")

      logger.warn _("DUG: Found host in DB via '#{params[:id]}', my_host is: #{@host.inspect}.")

      if @host.try(:certname)
        logger.warn _("DUG: Successfully found the certificate for this host, you rock!")
        logger.warn _("DUG: Deleting certificate #{@host.certname}.")
        api = ProxyAPI::Puppetca.new({:url => @host.puppet_ca_proxy.url})
        api.del_certificate(@host.certname)
        logger.warn _("DUG: Deleted certificate #{@host.certname}.")
        logger.warn _("DUG: local variables: #{local_variables}")
        logger.warn _("DUG: instance_variables: #{instance_variables}")
        logger.warn _("DUG: global variables: #{global_variables}")
      else
        logger.warn _("DUG: No certificate to delete: #{@host.inspect}.")
      end

      # logger.warn _(HostsController.public_instance_methods)
      # logger.warn _(self.public_methods)
      # logger.warn _(self.singleton_methods)
      # File.open('/tmp/dug.oot', 'w') {
      #   |file| file.write("clear_cert was called")
      # }
    end

    private

    def multiple_clear_cert
      @hosts.each do |host|
        logger.warn _("DUG: Deleting certificate #{host.certname}.")
      end
      notice _('Multiple certificates cleared')
      redirect_back_or_to hosts_path
    end

    def action_permission
      case params[:action]
      when 'clear_cert'
        :edit
      else
        super
      end
    end
  end
end
