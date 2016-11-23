class EmailSignupsController < ApplicationController
  protect_from_forgery except: [:create]

  def new
    @meta_section = subtopic.parent.title.downcase
    # Breadcrumbs for this page are hardcoded because it doesn't have a
    # content item with parents.
    @hardcoded_breadcrumbs = {
      breadcrumbs: [
        {
          title: "Home",
          url: "/",
        },
        {
          title: subtopic.parent.title,
          url: subtopic.parent.base_path,
        },
        {
          title: subtopic.title,
          url: subtopic.base_path,
        },
      ]
    }
    setup_content_item_and_navigation_helpers(subtopic)
  end

  def create
    if email_signup.save
      redirect_to email_signup.subscription_url
    else
      render action: 'new'
    end
  end

private

  def subtopic
    @subtopic ||= Topic.find("/topic/#{params[:topic_slug]}/#{params[:subtopic_slug]}")
  end
  helper_method :subtopic

  def email_signup
    @email_signup ||= EmailSignup.new(subtopic)
  end
  helper_method :email_signup
end
