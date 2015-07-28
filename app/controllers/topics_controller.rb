class TopicsController < ApplicationController
  before_filter :set_slimmer_format

  rescue_from GdsApi::ContentStore::ItemNotFound, :with => :error_404

  def index
    @topic = Topic.find(request.path)
  end

  def topic
    @topic = Topic.find(request.path)
  end

  def subtopic
    @subtopic = Topic.find(request.path)

    if @subtopic.parent
      set_slimmer_dummy_artefact(
        section_name: @subtopic.parent.title,
        section_link: @subtopic.parent.base_path
      )
    end
  end

  def latest_changes
    subtopic_base_path = request.path.sub(%r{/latest\z}, '')
    @subtopic = Topic.find(subtopic_base_path, pagination_params)
    @pagination_presenter = ChangedDocumentsPaginationPresenter.new(@subtopic.changed_documents, view_context)

    slimmer_artefact = {
      section_name: @subtopic.title,
      section_link: @subtopic.base_path,
    }
    if @subtopic.parent
      slimmer_artefact[:parent] = {
        section_name: @subtopic.parent.title,
        section_link: @subtopic.parent.base_path,
      }
    end
    set_slimmer_dummy_artefact(slimmer_artefact)
  end

private

  def organisations
    @organisations ||= subtopic_organisations(slug)
  end
  helper_method :organisations

  def set_slimmer_format
    set_slimmer_headers(format: "specialist-sector")
  end

  def slug
    "#{params[:topic_slug]}/#{params[:subtopic_slug]}"
  end

  def subtopic_organisations(slug)
    OrganisationsFacetPresenter.new(
      Collections::Application.config.search_client.unified_search(
        count: "0",
        filter_specialist_sectors: [slug],
        facet_organisations: "1000",
      )["facets"]["organisations"]
    )
  end

  def pagination_params
    params_to_use = params.slice(:start, :count).symbolize_keys

    # primitive sanitisation of the pagination parameters to ensure they're
    # integers
    params_to_use.inject({}) {|hash, (key, value)|
      hash[key] = value.to_i if value.present?
      hash
    }
  end
end
