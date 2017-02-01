# Provides our plugin code for clearing puppet certificates.
module CertReaper
  ##
  # Our Certificate Reaper's host controller inherits from Foreman's
  # HostsController. We use the puppet CA proxy's API to do the real
  # work.

  extend ProxyAPI

  ##
  # This class implements puppet certificate handling for foreman hosts.
  class HostsController < ::HostsController
    # Add our two "multiple" actions to the controller's MULTIPLE_ACTIONS array.
    MULTIPLE_ACTIONS << 'multiple_clear_cert'
    MULTIPLE_ACTIONS << 'submit_multiple_clear_cert'

    # Load our host resource before every clear_cert action.
    before_action :find_resource, :only => [:clear_cert]
    # Load our multiple host resources before our "multiple" actions.
    before_action :find_multiple, :only => MULTIPLE_ACTIONS

    ##
    # Our clear_cert action calls on our common code to clear the current
    # host's puppet certificate, pops up a notice informing the user of
    # the attempt to clear the puppet certificate and then redirects back to
    # the hosts page.
    def clear_cert
      # Our before action on the clear_cert method will have ensured that
      # our @host instance attribute is either a proper Host object or false.
      #
      # I'll assume we are always dealing with params[:id] and there
      # also seems to be a params[:host_id] in other parts of the code
      # which could lead to confusion (at least it does for me).
      logger.warn _("DUG: @host instance is: #{@host.inspect}.")
      host_clear_cert @host
      notice _('Cleared certificates for selected host: ' +
               @host.try(:certname))
      redirect_to(hosts_path)
    end

    ##
    # Our multiple_clear_cert action seeks confirmation from the user for the
    # selected hosts.
    def multiple_clear_cert
      # To be honest I'm not sure how, but this action causes the multi-host
      # confirmation dialog to be displayed so that the user can confirm their
      # selection.
    end

    ##
    # Our submit_multiple_clear_cert action is called after the user has
    # confirmed the multiple hosts for which they'd like puppet certificates
    # cleared. Again, we use our common code to clear the certificate for
    # each host. Once all the host certificates have been cleared we pop up
    # a notification dialog indicating the hosts involved and then redirect
    # to the hosts page.
    def submit_multiple_clear_cert
      # Okay, we've been given an array of hosts as an instance variable.
      # We'll call our common method to clear the host puppet certificate for
      # each host..
      logger.warn _("DUG: @hosts instance is: #{@hosts.inspect}.")
      @hosts.each do |host|
        host_clear_cert host
      end
      notice _('Cleared certificates for selected hosts: ' +
               @hosts.map(&:name).join(', '))
      redirect_to(hosts_path)
    end

    ##
    # Our action_permission action is called before any action to check that
    # the user has the appropriate access. To be honest I don't quite understand
    # how this works or what :edit does.
    def action_permission
      case params[:action]
      when 'clear_cert'
        :edit
      when 'multiple_clear_cert'
        :edit
      when 'submit_multiple_clear_cert'
        :edit
      else
        super
      end
    end

    private

    ##
    # Our private ca_feature? method determines if our list of features
    # contains the "Puppet CA" feature.
    def ca_feature?(features)
      features.find do |feature|
        if feature.try(:name)
          feature.name == 'Puppet CA'
        else
          false
        end
      end
    end

    ##
    # Our host_clear_cert method enumerates all known smart proxies,
    # We determine if they implement the "Puppet CA" feature and, if they do,
    # we ask the puppet ProxyAPI to clear the certificate for the cert name.
    def host_clear_cert(host)
      return unless host.try(:certname) # Our host doesn't have a certname!
      # Enumerate all our host's smart proxies.
      SmartProxy.all do |smart_proxy|
        # Check if this proxy is relevant i.e. has features, has a CA proxy
        # feature and an associated proxy URL.
        next unless smart_proxy.try(:features)
        next unless ca_feature? smart_proxy.features
        next unless smart_proxy.try(:url)
        # This is, indeed, a puppet CA smart proxy we can bend to our will.
        api = ProxyAPI::Puppetca.new(:url => smart_proxy.url)
        api.del_certificate(host.certname)
      end
    end
  end
end
