class Rails::Rack::Logger
  protected
  def started_request_message(request)
    "%-7s IP: %-15s |  %s\nURL:    \"%s\"" % [request.request_method,
                                              request.ip,
                                              Time.now.to_default_s,
                                              request.filtered_path,]
  end
end
