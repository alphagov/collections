class EmailSignupsController < ApplicationController
  protect_from_forgery except: [:create]

  def new
    return error_404 unless subtopic.present?
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
    @subtopic ||= Subcategory.find(params[:subtopic])
  end
  helper_method :subtopic

  def email_signup
    @email_signup ||= EmailSignup.new(subtopic)
  end
  helper_method :email_signup
end
