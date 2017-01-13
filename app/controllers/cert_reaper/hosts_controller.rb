module CertReaper
  ##
  # Our Certificate Reaper's host controller inherits from Foreman's
  # HostsController.

  extend ProxyAPI

  class HostsController < ::HostsController
    ##
    # This class implements puppet certificate handling for foreman hosts.

    MULTIPLE_ACTIONS << 'multiple_clear_cert'
    MULTIPLE_ACTIONS << 'submit_multiple_clear_cert'
    logger.warn _("DUG: MULTIPLE ACTIONS = #{MULTIPLE_ACTIONS.inspect}")
    before_action :find_resource, :only => [:clear_cert]
    before_action :find_multiple, :only => MULTIPLE_ACTIONS
#    before_action :find_multiple, :only => [:submit_multiple_clear_cert] #MULTIPLE_ACTIONS

    # def resource_base
    #   base = super
    #   base = base.eager_load(:locations) if SETTINGS[:locations_enabled]
    #   base = base.eager_load(:organizations) if SETTINGS[:organizations_enabled]
    #   base
    # end

    def clear_cert
      ##
      # Our before action on the clear_cert method will have ensured
      # that our @host instance attribute is either a proper Host object or false. 
      #
      # I'll assume we are always dealing with params[:id] and there
      # also seems to be a params[:host_id] in other parts of the code
      # which could lead to confusion (at least it does for me.
      logger.warn _("DUG: params is: #{params.inspect}.")
      logger.warn _("DUG: @host instance is: #{@host.inspect}.")
      logger.warn _("DUG: class of params[:id] is: #{params[:id].class}.")
      logger.warn _("DUG: inspect of params[:id] is: #{params[:id].inspect}.")
      logger.warn _("DUG: Smart Proxy is #{SmartProxy.inspect}")
      logger.warn _("DUG: Foreman settings we know are: #{SETTINGS.inspect}")
      host_clear_cert @host
      logger.warn _("DUG: local variables: #{local_variables}")
      logger.warn _("DUG: instance_variables: #{instance_variables}")
      logger.warn _("DUG: global variables: #{global_variables}")
      notice _('Cleared certificates for selected host: ' + @host.certname)
      redirect_to(hosts_path)

      # logger.warn _(HostsController.public_instance_methods)
      # logger.warn _(self.public_methods)
      # logger.warn _(self.singleton_methods)
      # File.open('/tmp/dug.oot', 'w') {
      #   |file| file.write("clear_cert was called")
      # }
    end

    def multiple_clear_cert
      logger.warn _("DUG: INSIDE multiple_clear_cert called. We have params: #{params.inspect}.")
      logger.warn _("DUG: INSIDE multiple_clear_cert called. We have @hosts: #{@hosts.inspect}.")
      hosts = @hosts
    end

    def submit_multiple_clear_cert
      logger.warn _("DUG: INSIDE submit_multiple_clear_cert called. We have params: #{params.inspect}.")
      find_multiple
      logger.warn _("DUG: INSIDE submit_multiple_clear_cert called. We have @hosts: #{@hosts.inspect}.")
      @hosts.each do |host|
        host_clear_cert host
      end
      notice _('Cleared certificates for selected hosts: ' + @hosts.map(&:name).join(', '))
      redirect_to(hosts_path)
    end

    def action_permission
      logger.warn _("DUG: INSIDE action_permission called. We have params: #{params.inspect}.")
      case params[:action]
      when 'clear_cert'
        logger.warn _("DUG: when clear_cert go to edit.")
        :edit
      when 'multiple_clear_cert'
        logger.warn _("DUG: when multiple_clear_cert go to edit.")
        :edit
      when 'submit_multiple_clear_cert'
        logger.warn _("DUG: when submit_multiple_clear_cert go to edit.")
        :edit
      else
        super
      end
    end

    private
      def has_CA_feature?(features)
        features.find { |feature|
          if feature.try(:name)
            logger.warn _("DUG: Checking feature name: #{feature.name} against 'Puppet CA'.")
            logger.warn _("DUG: Inspecting feature: #{feature.inspect}.")
            feature.name == 'Puppet CA'
          else
            logger.warn _("DUG: feature had no name.")
            false
          end
        }
      end

      def host_clear_cert(host)
        if host.try(:certname)
          smart_proxies = SmartProxy.all
          smart_proxies.each do |smart_proxy|
            logger.warn _("DUG: smart_proxy class is: #{smart_proxy.class}")
            logger.warn _("DUG: Inspecting smart_proxy: #{smart_proxy.inspect}")
            if smart_proxy.try(:features)
              if has_CA_feature? smart_proxy.features
                if smart_proxy.try(:url)
                  api = ProxyAPI::Puppetca.new({:url => smart_proxy.url})
                  api.del_certificate(host.certname)
                  logger.warn _("DUG: Deleted certificate #{host.certname}.")
                  notice _("DUG: Deleted certificate #{host.certname}.")
                else
                  logger.warn _("DUG: No url for proxy #{smart_proxy.inspect}.")
                end
              else
                logger.warn _("DUG: No CA feature found in smart_proxy.features: #{smart_proxy.features.inspect}.")
              end
            else
              logger.warn _("DUG: No features found in smart_proxy: #{smart_proxy.inspect}.")
            end
          end
          # api = ProxyAPI::Puppetca.new({:url => host.puppet_ca_proxy.url})
          # api.del_certificate(host.certname)
        else
          logger.warn _("DUG: No certname in host: #{host.inspect}.")
        end
      end

  end
end
