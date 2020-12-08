class PeopleController < ApplicationController
  around_action :switch_locale

  def show
    @person = Person.find!(request.path)
    setup_content_item_and_navigation_helpers(@person)
    render :show, locals: { person: @person }
  end
end
