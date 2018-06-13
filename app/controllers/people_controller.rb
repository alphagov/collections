class PeopleController < ApplicationController
  def show
    @person = Person.find!("/government/people/#{params[:name]}")
    setup_content_item_and_navigation_helpers(@person)
    render :show, locals: {
        person: @person
    }
  end
end
