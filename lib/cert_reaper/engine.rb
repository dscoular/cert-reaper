require 'deface'

module CertReaper
  class Engine < ::Rails::Engine
    engine_name 'cert_reaper'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'cert_reaper.load_app_instance_data' do |app|
      CertReaper::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'cert_reaper.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :cert_reaper do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :cert_reaper do
          permission :view_cert_reaper, :'cert_reaper/hosts' => [:new_action]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'CertReaper', [:view_cert_reaper]

        # add menu entry
        menu :top_menu, :template,
             url_hash: { controller: :'cert_reaper/hosts', action: :new_action },
             caption: 'CertReaper',
             parent: :hosts_menu,
             after: :hosts

        # add dashboard widget
        widget 'cert_reaper_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'cert_reaper.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'cert_reaper.configure_assets', group: :assets do
      SETTINGS[:cert_reaper] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, CertReaper::HostExtensions)
        HostsHelper.send(:include, CertReaper::HostsHelperExtensions)
        HostsController.send(:include, CertReaper::HostsControllerExtensions)
      rescue => e
        Rails.logger.warn "CertReaper: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        CertReaper::Engine.load_seed
      end
    end

    initializer 'cert_reaper.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'cert_reaper'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
