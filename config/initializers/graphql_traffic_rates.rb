Rails.application.config.graphql_traffic_rates = ENV
  .select { |key, _| key.starts_with?("GRAPHQL_RATE_") }
  .transform_keys { |key| key.sub(/^GRAPHQL_RATE_/, "").downcase }
  .transform_values(&:to_f)
