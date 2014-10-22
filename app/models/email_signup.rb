require 'active_model'

class EmailSignup
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Validations

  validates_presence_of :subtopic

  attr_reader :subscription_url

  def initialize(subtopic)
    @subtopic = subtopic
  end

  def save
    if valid?
      @subscription_url = find_or_create_subscription.subscriber_list.subscription_url
      true
    end
  end

  def find_or_create_subscription
    Collections.services(:email_alert_api)
      .find_or_create_subscriber_list(subscription_params)
  end

  def valid?
    super && subtopic.present?
  end

  def persisted?
    false
  end

private

  attr_reader :subtopic

  def subscription_params
    {
      title: subtopic.combined_title,
      tags: {
        topic: [subtopic.slug]
      }
    }.deep_stringify_keys
  end
end
