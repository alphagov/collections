class EmailSignupsController < ApplicationController
  protect_from_forgery except: [:create]

  def new
    setup_navigation_helpers(subtopic)

    render :new, locals: {
      subtopic: subtopic,
      hardcoded_breadcrumbs: hardcoded_breadcrumbs,
      meta_section: meta_section
    }
  end

  def create
    if email_signup.save
      redirect_to email_signup.subscription_url
    else
      render :new, locals: {
        subtopic: subtopic,
        hardcoded_breadcrumbs: hardcoded_breadcrumbs,
        meta_section: meta_section
      }
    end
  end

private

  # Breadcrumbs for this page are hardcoded because it doesn't have a
  # content item with parents.
  def hardcoded_breadcrumbs
    {
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
  end

  def meta_section
    subtopic.parent.title.downcase
  end

  def subtopic
    @subtopic ||= Topic.find(
      "/topic/#{params[:topic_slug]}/#{params[:subtopic_slug]}"
    )
  end
  helper_method :subtopic

  def email_signup
    @email_signup ||= EmailSignup.new(subtopic)
  end
  helper_method :email_signup
end
