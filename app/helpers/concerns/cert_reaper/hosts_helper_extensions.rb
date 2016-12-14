module CertReaper
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks

      # This is ruby voodoo that lest you alias the original method to your
      # new method and keep the original method around too. From the doco:
      #
      # alias_method_chain(target, feature) public
      #
      # Encapsulates the common pattern of:
      #
      #    alias_method :foo_without_feature, :foo
      #    alias_method :foo, :foo_with_feature
      #
      # With this, you simply do:
      #
      # alias_method_chain :foo, :feature
      #
      # And both aliases are set up for you. 

      #
      alias_method_chain :host_title_actions, :clear
      alias_method_chain :show_appropriate_host_buttons, :clear
      alias_method_chain :overview_fields, :clear
    end

    def host_title_actions_with_clear(host)
      logger.warn("DUG: host_title_actions_with_clear_cert() got called!!!")
      title_actions(
        button_group(
                     # if host.try(:puppetca_proxy)
                       link_to_if_authorized(_('Clear Cert'), { :controller => :'cert_reaper/hosts', :action => :clear_cert, :id => host },
                                             :title => _("Clear this host's puppet certificate"))
                     # end
                     )
                    )
      host_title_actions_without_clear(host)
    end

    def show_appropriate_host_buttons_with_clear(host)
      logger.warn("DUG: show_appropriate_host_buttons_with_clear_cert() got called!!!")
      (show_appropriate_host_buttons_without_clear(host) +
       [(link_to_if_authorized(_('Clear Cert'), { :controller => :'cert_reaper/hosts', :action => :clear_cert, :id => host },
                               :title => _("Clear this host's puppet certificate"), :class => 'btn btn-default'))]).flatten.compact
    end

    def overview_fields_with_clear(host)
      # I'm not sure where this appears on the user-interface.
      logger.warn("DUG: overview_fields_with_clear_cert() got called!!!")
      fields = overview_fields_without_clear(host)

      # fields.insert(5, [_('Salt Master'), (link_to(host.salt_proxy, hosts_path(:search => "saltmaster = #{host.salt_proxy}")) if host.salt_proxy)])
      # fields.insert(6, [_('Salt Environment'), (link_to(host.salt_environment, hosts_path(:search => "salt_environment = #{host.salt_environment}")) if host.salt_environment)])

      #fields
    end

    def clear_cert_host_dialog(host)
      _("Are you sure you want to clear the puppet certificate on  the host: %s?") % host.name
    end
  end
end
