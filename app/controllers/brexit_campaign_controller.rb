class BrexitCampaignController < ApplicationController
  def show
    @campaign = Organisation.find!("/government/organisations/cabinet-office")
    setup_content_item_and_navigation_helpers(@campaign)

    main_taxons = ContentItem.find!("/").to_hash['links']['level_one_taxons']
    @taxons_content_item = main_taxons.map do |taxon|
      {
        base_path: taxon['base_path'],
        title: taxon['title']
      }
    end

    @taxons_content_item.sort_by! { |taxon| taxon[:title] }

    @show = Organisations::ShowPresenter.new(@campaign)
    @header = Organisations::HeaderPresenter.new(@campaign)

    # @documents = Organisations::DocumentsPresenter.new(@campaign)
    @documents = Organisations::DocumentsPresenter.new(@campaign)
    # @latest_docs = @documents.latest_documents_by_type.in_groups_of(2, false) do |documents_group|
      #test = 1
    #end

    @what_we_do = Organisations::WhatWeDoPresenter.new(@campaign)
    @people = Organisations::PeoplePresenter.new(@campaign)
    @not_live = Organisations::NotLivePresenter.new(@campaign)
    @contacts = Organisations::ContactsPresenter.new(@campaign)

    render :show, locals: {
      campaign: @campaign
    }
  end
end
