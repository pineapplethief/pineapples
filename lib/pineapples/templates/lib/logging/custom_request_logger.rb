require 'show_data'

module CustomRequestLogger
  class LogSubscriber < ActiveSupport::LogSubscriber
    INTERNAL_PARAMS = %w(controller action format _method only_path)

    def start_processing(event)
      payload = event.payload
      params  = payload[:params].except(*INTERNAL_PARAMS)
      format  = payload[:format]
      format  = format.to_s.upcase if format.is_a?(Symbol)

      info "Action: #{payload[:controller]}##{payload[:action]} \nFormat: #{format}"
      #logger.info "Parameters: #{params.inspect}" unless params.empty?
    end

    def process_action(event)
      indent = 8
      payload = event.payload
      param_method = payload[:params]['_method']
      status = compute_status(payload)
      path = payload[:path]
      params = payload[:params].except(*INTERNAL_PARAMS)

      redirect_to = Thread.current[:redirect_to]
      Thread.current[:redirect_to] = nil

      message = "Status: #{status} for \"#{path}\" \n"
      message << "Redirect URL: #{redirect_to} \n" if redirect_to
      message << "Params: #{format_data(params, indent)} \n" if params.present?

      info(message)
    end

    def redirect_to(event)
      Thread.current[:redirect_to] = event.payload[:location]
    end

    private
    def compute_status(payload)
      status = payload[:status]
      if status.nil? && payload[:exception].present?
        exception_class_name = payload[:exception].first
        status = ActionDispatch::ExceptionWrapper.status_code_for_exception(exception_class_name)
      end
      status
    end

  end

  class Formatter < Logger::Formatter
    def call(severity, time, progname, msg)
      msg = msg.is_a?(String) ? msg : msg.inspect
      "#{Rails.env.production? ? severity : ''} #{time.utc.strftime('%F %T')} #{msg} \n"
    end
  end
end

%w(process_action start_processing).each do |event|
  ActiveSupport::Notifications.unsubscribe "#{event}.action_controller"
end

CustomRequestLogger::LogSubscriber.attach_to :action_controller
