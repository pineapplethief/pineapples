Rails.application.configure do
  config.cache_classes = true

  # Avoid Spring issues when running simple_cov
  config.eager_load = false
  config.serve_static_files = false

  # Configure static file server for tests with Cache-Control for performance.
  config.serve_static_files   = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true

  config.action_controller.perform_caching = false

  config.action_controller.allow_forgery_protection = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'www.example.com' }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  config.active_support.test_order = :random

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  config.active_job.queue_adapter = :inline
end
