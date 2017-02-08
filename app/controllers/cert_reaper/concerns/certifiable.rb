module CertReaper
  module Concerns
    ##
    # Our common puppet certificate handling code. I couldn't resist calling
    # it "certifiable" but it's really just the certificate handling code
    # shared between the Host controller and the API controller.
    module Certifiable
      # I don't think this does anything without calling "included".
      # It works without extending ActiveSupport::Concern. I've just
      # left it in because all the examples show it and we're in the
      # controller/concerns directory.
      # If anyone can explain why I need this please contact me at:
      # dscoular@gmail.com.
      extend ActiveSupport::Concern

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
end
