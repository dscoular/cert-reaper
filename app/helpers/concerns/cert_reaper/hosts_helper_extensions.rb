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
      # DUG: looked odd: alias_method_chain :host_title_actions, :clear
      alias_method_chain :show_appropriate_host_buttons, :clear
      # alias_method_chain :overview_fields, :clear
      alias_method_chain :multiple_actions, :clear
    end

    # This is the row of buttons in the host details page on the right.
    # I decided not to alias (use) this as it makes the button group look odd.
    def retired_host_title_actions_with_clear(host)
      logger.warn _('DUG: Inside host_title_actions_with_clear_cert() got called!!!')
      logger.warn _("DUG: we were passed this host: #{host.inspect}.")
      logger.warn _("DUG: the class of the host param is: #{host.class}.")
      logger.warn _("DUG: the instance @host: #{@host.inspect}.")
      logger.warn _("DUG: the class of the instance @host is: #{@host.class}.")
      if host.try(:puppetca_proxy)
        logger.warn _('DUG: the host has a puppetca_proxy.')
      end
      if host.try(:puppetca_proxy_id)
        logger.warn _('DUG: the host has a puppetca_proxy.')
      end
      title_actions(
        button_group(
                     # if host.try(:puppetca_proxy)
#DUG                       link_to_if_authorized(_('Clear Cert'), { :controller => :'cert_reaper/hosts', :action => :clear_cert, :id => host },
#DUG                                             :title => _("Clear this host's puppet certificate"))
                     # end
                     link_to_if_authorized(_("Clear Cert"), hash_for_clear_cert_path(:id => host).merge(:auth_object => host, :permission => 'view_cert_reaper'),
                                  :disabled => !Setting[:puppetrun],
                                  :class => 'btn btn-default',
                                  :title    => _("Clear a puppet certificate on this host."))

                     )
                    )
      host_title_actions_without_clear(host)
    end

    # This is the row of buttons in the host details page on the left.
    def show_appropriate_host_buttons_with_clear(host)
      logger.warn _("DUG: Inside show_appropriate_host_buttons_with_clear() got called!!!")
      logger.warn _("DUG: we were passed this host: #{host.inspect}.")
      logger.warn _("DUG: the class of the host param is: #{host.class}.")
      logger.warn _("DUG: the instance @host: #{@host.inspect}.")
      logger.warn _("DUG: the class of the instance @host is: #{@host.class}.")
      if host.try(:puppet_ca_proxy_id)
        logger.warn _("DUG: the host has a puppetca_proxy.")
      end

      my_test = hash_for_clear_cert_path(:id => host)
      logger.warn _("DUG: hash_for_clear_cert_path(:id => host) returned: #{my_test}.")
      (show_appropriate_host_buttons_without_clear(host) +
       [ link_to_if_authorized(_('Clear Cert'), 
                               hash_for_clear_cert_path(:id => host),
                               :title => _('Clear this host\'s puppet certificate.'),
                               :class => 'btn btn-default'),
         # (link_to_if_authorized(_('Clear Certy'), { :controller => :'cert_reaper/hosts', :action => :clear_cert, :id => host }, :title => _("Clear this host's puppet certificate"), :class => 'btn btn-default'))
       ]).flatten.compact
    end

    def retired_overview_fields_with_clear(host)
      # I'm not sure where this appears on the user-interface. I got it from the
      # salt plugin.
      logger.warn('DUG: overview_fields_with_clear_cert() got called!!!')
      fields = overview_fields_without_clear(host)

      # fields.insert(5, [_('Salt Master'), (link_to(host.salt_proxy, hosts_path(:search => "saltmaster = #{host.salt_proxy}")) if host.salt_proxy)])
      # fields.insert(6, [_('Salt Environment'), (link_to(host.salt_environment, hosts_path(:search => "salt_environment = #{host.salt_environment}")) if host.salt_environment)])

      #fields
    end

    def multiple_actions_with_clear
      ## Handle multiple host actions and add clear certificate option.
      logger.warn('DUG: multiple_actions_with_clear() got called!!!')
      actions = multiple_actions_without_clear
      actions << [ _('Clear puppet Certificates'), multiple_clear_cert_path]
      #actions << [_('Clear Puppet Certificate'), multiple_puppetrun_hosts_path]
      #actions << [ _('Clear Puppet Certificate'), { :controller => 'cert_reaper/hosts', :action => :multiple_clear_cert, :title => _("Clear selected host's puppet certificate.") } ]
      #actions <<  [_('Assign Org by Dug'), select_multiple_organization_hosts_path]
      logger.warn('DUG:MULTIPLE_ACTIONS CALLED!' + actions.inspect)
      #logger.warn _("DUG: Public instance methods: " + self.public_instance_methods)
      logger.warn _("DUG: Public class methods: " + self.public_methods.join(' '))
      logger.warn _("DUG: Public methods: " + public_methods.join(' '))
      logger.warn _("DUG: Public class singleton methods: " + self.singleton_methods.join(' '))
      logger.warn _("DUG: Public singleton methods: " + singleton_methods.join(' '))
      actions
      #actions <<  [_('Clear Puppet Certificate'),
      #  multiple_puppetrun_hosts_path] if Setting[:puppetrun] &&
      #             authorized_for(:controller => :hosts, :action => :puppetrun)
    end

    def clear_cert_host_dialog(host)
      _("Are you sure you want to clear the puppet certificate on the host: '%s'?") % host.name
    end
  end
end
