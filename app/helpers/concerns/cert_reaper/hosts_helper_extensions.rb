# Enhance the hosts helper extension with our "clear cert" related UI widgets.
module CertReaper
  module HostsHelperExtensions
    ##
    # Our Certificate Reaper's hosts helper inherits from ActiveSupport
    # Concern. We make use of the alias_method_chain to add our
    # "clear cert" related UI widgets to the user-interface.

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
      alias_method_chain :show_appropriate_host_buttons, :clear
      alias_method_chain :multiple_actions, :clear
    end

    ##
    # This adds our "clear cert" button to the row of buttons in the host
    # details page on the left-hand side.
    def show_appropriate_host_buttons_with_clear(host)
      logger.warn _("DUG: we were passed this host: #{host.inspect}.")

      (show_appropriate_host_buttons_without_clear(host) +
       [link_to_if_authorized(_('Clear Cert'),
                              hash_for_clear_cert_path(:id => host),
                              :title =>
                              _('Clear this host\'s puppet certificate.'),
                              :class => 'btn btn-default')]).flatten.compact
    end

    ##
    # This adds our "multiple clear cert" action to the existing actions.
    def multiple_actions_with_clear
      # Handle multiple host actions and add clear certificate option.
      actions = multiple_actions_without_clear
      actions << [_('Clear puppet Certificates'), multiple_clear_cert_path]
      actions
    end

    ##
    # This seems to get called automagically when we clear a single certificate.
    # I'm not sure how this works. I wish I could remember how I discovered it.
    def clear_cert_host_dialog(host)
      _('Are you sure you want to clear the puppet certificate on ' \
        "the host: '%s'?") % host.name
    end
  end
end
