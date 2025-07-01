module PrometheusSupport
  def set_prometheus_labels("graphql_status_code" => 200, "graphql_contains_errors" => false, "graphql_api_timeout" => false)
    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})

    hash = {
      "graphql_status_code" => graphql_status_code,
      "graphql_contains_errors" => graphql_contains_errors,
      "graphql_api_timeout" => graphql_api_timeout,
    }

    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(hash)
  end
end
