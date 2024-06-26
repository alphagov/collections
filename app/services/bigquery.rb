require "google/cloud/bigquery"
require "googleauth"

class Bigquery
  include Google::Auth

  def self.build
    new.build
  end

  def build
    credentials = {
      "client_email" => ENV["BIGQUERY_CLIENT_EMAIL"],
      "private_key" => ENV["BIGQUERY_PRIVATE_KEY"],
    }

    Google::Cloud::Bigquery.new(
      project_id: ENV["BIGQUERY_PROJECT"],
      credentials: Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(credentials.to_json),
        scope: ["https://www.googleapis.com/auth/bigquery"],
      ),
    )
  end
end
