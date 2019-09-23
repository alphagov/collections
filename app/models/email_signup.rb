require "active_model"

class EmailSignup
  include ActiveModel::Model

  validates_presence_of :subtopic

  attr_reader :subscription_url

  def initialize(subtopic)
    @subtopic = subtopic
  end

  def save
    if valid?
      @subscription_url = find_or_create_subscription.dig("subscriber_list", "subscription_url")
    end
  end

  def find_or_create_subscription
    Services.email_alert_api.find_or_create_subscriber_list(subscription_params)
  end

private

  attr_reader :subtopic

  def subscription_params
    {
      "title" => subtopic.combined_title,
      "links" => {
        "topics" => [subtopic.content_id],
      },
    }
  end
end
