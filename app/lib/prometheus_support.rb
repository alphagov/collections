module PrometheusSupport
  def set_prometheus_labels(hash)
    return unless hash

    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})

    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(hash)
  end
end
