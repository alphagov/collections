class CategoriesController < ApplicationController
  def show
    organisation, supergroup, taxon = nil, nil, nil

    parts = params[:category].split('/')

    if taxon = find_taxon(File.join('/', *parts))
      organisation = nil
      supergroup = nil

    elsif taxon = find_taxon(File.join('/', *parts.drop(1)))
      if supergroup = find_supergroup(parts.first)&.dig('id')
        organisation = nil
      elsif organisation = find_organisation(parts.first)
        supergroup = nil
      else
        render status: :not_found and return
      end

    elsif taxon = find_taxon(File.join('/', *parts.drop(2)))
      supergroup = find_supergroup(parts[1])&.dig('id')
      organisation = find_organisation(parts[0])

      if supergroup.nil? || organisation.nil?
        render status: :not_found and return
      end

    else
      render status: :not_found and return

    end

    setup_content_item_and_navigation_helpers(taxon)

    if organisation && supergroup && taxon
      organisation_param = organisation.base_path.split('/').last

      page_prefix = "/browse/#{organisation_param}/#{supergroup.dasherize}"

      page_title = supergroup.humanize
      page_description = taxon.description
      page_context = { text: organisation.title, href: page_prefix }
      page_breadcrumbs = [
        { title: 'Home', url: '/' },
        { title: organisation.title, url: organisation.base_path },
        { title: supergroup.humanize, url: supergroup.dasherize },
      ] +
        GovukPublishingComponents::AppHelpers::TaxonBreadcrumbs
          .new(@content_item)
          .breadcrumbs[1..-1]
          .each { |breadcrumb| breadcrumb[:url] = page_prefix + breadcrumb[:url] } +
        [
          { title: taxon.title }
        ]


    elsif organisation && taxon
      organisation_param = organisation.base_path.split('/').last

      page_prefix = "/browse/#{organisation_param}"

      page_title = taxon.title
      page_description = taxon.description
      page_context = { text: organisation.title, href: page_prefix }
      page_breadcrumbs = [
        { title: 'Home', url: '/' },
        { title: organisation.title, url: organisation.base_path },
      ] +
        GovukPublishingComponents::AppHelpers::TaxonBreadcrumbs
          .new(@content_item)
          .breadcrumbs[1..-1]
          .each { |breadcrumb| breadcrumb[:url] = page_prefix + breadcrumb[:url] }


    elsif supergroup && taxon
      page_title = supergroup.humanize
      page_description = taxon.description
      page_prefix = "/browse/#{supergroup.dasherize}"
      page_context = { text: taxon.title }
      page_breadcrumbs = [
        { title: 'Home', url: '/' },
        { title: supergroup.humanize, url: "/browse/#{supergroup.dasherize}" },
      ] +
        GovukPublishingComponents::AppHelpers::TaxonBreadcrumbs
          .new(@content_item)
          .breadcrumbs[1..-1]
          .each { |breadcrumb| breadcrumb[:url] = page_prefix + breadcrumb[:url] } +
        [
          { title: taxon.title }
        ]


    elsif taxon
      page_title = taxon.title
      page_context = nil
      page_description = taxon.description
      page_prefix = "/browse"
      page_breadcrumbs =
        GovukPublishingComponents::AppHelpers::TaxonBreadcrumbs
          .new(@content_item)
          .breadcrumbs
          .each { |breadcrumb| breadcrumb[:url] = page_prefix + breadcrumb[:url] }

    end

    page = Integer(params[:page] || 1)
    order = params[:order] || case supergroup
                              when 'services'
                                'a-z'
                              when 'news_and_communications'
                                'newest'
                              else
                                'popularity'
                              end

    if supergroup != 'services' and order == 'a-z'
      order = 'popularity'
      params[:order] = nil
    end

    documents = case order
                when 'a-z'
                  Services
                    .rummager
                    .search_enum(
                      fields: %w(title description link taxons content_store_document_type public_timestamp),
                      filter_content_purpose_supergroup: supergroup,
                      filter_organisations: Array(organisation_param),
                      filter_part_of_taxonomy_tree: Array(taxon.content_id),
                      order: case order
                             when 'newest'
                               '-public_timestamp'
                             else
                               nil
                             end,
                    )
                else
                  Services
                    .rummager
                    .search(
                      fields: %w(title description link taxons content_store_document_type public_timestamp),
                      filter_content_purpose_supergroup: supergroup,
                      filter_organisations: Array(organisation_param),
                      filter_part_of_taxonomy_tree: Array(taxon.content_id),
                      order: case order
                             when 'newest'
                               '-public_timestamp'
                             else
                               nil
                             end,
                      start: page,
                      count: 20,
                    )
                    .to_h
                    .fetch('results', [])
                end

    render :show,
           locals: {
             documents: documents,
             order: order,
             organisation: organisation,
             organisation_param: organisation_param,
             page: page,
             page_breadcrumbs: page_breadcrumbs,
             page_context: page_context,
             page_description: page_description,
             page_prefix: page_prefix,
             page_title: page_title,
             supergroup: supergroup,
             taxon: TaxonPresenter.new(taxon),
           }
  end

  private

  def find_organisation(id)
    if organisation = Organisation.find!(File.join('/', *%w(government organisations), id))
      if organisation.content_item.document_type == 'organisation'
        organisation
      end
    end
  end

  def find_supergroup(id)
    GovukDocumentTypes::SUPERGROUPS
      .dig('content_purpose_supergroup', 'items')
      .detect { |supergroup| supergroup['id'] == id.underscore }
  end

  def find_taxon(path)
    Taxon.find(path)
  rescue StandardError
    nil
  end
end
