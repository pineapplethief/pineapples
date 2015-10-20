Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.assets.debug = true

  # Source maps for SASS
  config.sass.inline_source_maps = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.action_view.logger = nil
  config.quiet_assets = false if ENV['LOG_ASSETS']

  url = ENV['DOMAIN_URL'] || 'http://localhost:3000'

  Rails.application.routes.default_url_options = {url: url}

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = SMTP_SETTINGS

  config.action_mailer.default_url_options = {url: url}

  config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.delivery_method = :test

  config.web_console.whitelisted_ips = '192.168.0.0/16'
  config.web_console.whiny_requests = false

  # Settings specified here will take precedence over those in config/application.rb.
  live_reload_options = {
    min_delay:    1000,    # default 1000
    max_delay:    15_000, # default 60_000
    no_swf:       true
    #source:       :livereload

    #live_reload_port: 56789,  # default 35729
    #host:             url.host,
    #ignore:           [ %r{dont/modify\.html$} ]
  }

  config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload, live_reload_options)

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true
end
