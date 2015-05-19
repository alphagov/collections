class EmailSignupsController < ApplicationController
  protect_from_forgery except: [:create]

  def new
    return error_404 unless subtopic.present?

    set_slimmer_dummy_artefact(
      section_name: subtopic.title,
      section_link: subcategory_path(sector: subtopic.parent_slug, subcategory: subtopic.child_slug),
      parent: {
        section_name: subtopic.parent_sector_title,
        section_link: "/#{subtopic.parent_slug}",
      }
    )
  end

  def create
    return error_404 unless subtopic.present?

    if email_signup.save
      redirect_to email_signup.subscription_url
    else
      render action: 'new'
    end
  end

private

  def subtopic
    @subtopic ||= Subtopic.find("#{params[:sector]}/#{params[:subcategory]}")
  end
  helper_method :subtopic

  def email_signup
    @email_signup ||= EmailSignup.new(subtopic)
  end
  helper_method :email_signup
end
