GovukError.configure do |config|
  # A couple of hundred timeouts occur each day. This can be caused by
  # rummager or content-store being busy, or network issues. They generally
  # aren't a big deal, since Fastly will show the mirror. We can safely
  # ignore the errors because we have other monitoring in place that alerts
  # us if the error rate reaches certain thresholds.
  config.excluded_exceptions << "GdsApi::TimedOutException"

  config.should_capture = Proc.new { |e|
    # We're overriding the `should_capture` block here:
    # https://github.com/alphagov/govuk_app_config/blob/master/lib/govuk_app_config/configure.rb#L9-L19
    GovukStatsd.increment("errors_occurred")
    GovukStatsd.increment("errbit.errors_occurred")

    !e.cause.class.name.in?(config.excluded_exceptions)
  }
end
