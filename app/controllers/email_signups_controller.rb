class EmailSignupsController < ApplicationController
  protect_from_forgery except: [:create]

  rescue_from GdsApi::HTTPNotFound, :with => :error_404

  def new
    slimmer_artefact = {
      section_name: subtopic.title,
      section_link: subtopic.base_path,
    }
    if subtopic.parent
      slimmer_artefact[:parent] = {
        section_name: subtopic.parent.title,
        section_link: subtopic.parent.base_path,
      }
    end
    set_slimmer_dummy_artefact(slimmer_artefact)
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
    @subtopic ||= Subtopic.find("/#{params[:topic_slug]}/#{params[:subtopic_slug]}")
  end
  helper_method :subtopic

  def email_signup
    @email_signup ||= EmailSignup.new(subtopic)
  end
  helper_method :email_signup
end
