module CertReaper
  ##
  # Our Certificate Reaper's host controller inherits from Foreman's
  # HostsController.

  extend ProxyAPI

  class HostsController < ::HostsController
    ##
    # This class implements puppet certificate handling for foreman hosts.

    #MULTIPLE_ACTIONS << %w(multiple_clear_cert)

    before_action :find_resource, :only => [:clear_cert]
    before_action :find_multiple, :only => [:multiple_clear_cert] #MULTIPLE_ACTIONS

    def clear_cert
      ##
      # Our before action on the clear_cert method will have ensured
      # that our @host instance is either a proper Host object or false. 
      #
      # I'll assume we are always dealing with params[:id] and there
      # also seems to be a params[:host_id] in other parts of the code
      # which could lead to confusion (at least it does for me.
      logger.warn _("DUG: params is: #{params.inspect}.")
      logger.warn _("DUG: class of params[:id] is: #{params[:id].class}.")
      logger.warn _("DUG: inspect of params[:id] is: #{params[:id].inspect}.")
      logger.warn _("DUG: Smart Proxy is #{SmartProxy.inspect}")
      logger.warn _("DUG: Foreman settings we know are: #{SETTINGS.inspect}")
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

    def multiple_clear_cert
      logger.warn _("DUG: multiple_clear_cert called. We have hosts: #{@hosts.inspect}.")
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
