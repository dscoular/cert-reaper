module CertReaper
  module Concerns
    module HostsControllerExtensions
      extend ActiveSupport::Concern

      included do
        alias_method_chain :multiple_actions, :clear
      end

      def multiple_actions_with_clear
        logger.warn('DUG: multiple_actions_with_clear() got called!!!')
        actions = multiple_actions_without_clear
        actions << [_('Clear Puppet Certificate'), multiple_clear_cert]

        logger.warn('DUG:MULTIPLE_ACTIONS CALLED!' + actions.inspect)
        #      actions <<  [_('Clear Puppet Certificate'),
        #             multiple_puppetrun_hosts_path] if Setting[:puppetrun] &&
        #             authorized_for(:controller => :hosts, :action => :puppetrun)
      end
    end
  end
end
