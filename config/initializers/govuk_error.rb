GovukError.configure do |config|
  # A couple of hundred timeouts occur each day. This can be caused by
  # rummager or content-store being busy, or network issues. They generally
  # aren't a big deal, since Fastly will show the mirror. We can safely
  # ignore the errors because we have other monitoring in place that alerts
  # us if the error rate reaches certain thresholds. 
  config.excluded_exceptions << "GdsApi::TimedOutException"
end
