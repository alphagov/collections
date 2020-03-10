Before("@mock-email-alert-api") do
  Services.stubs(email_alert_api: mock)
end
