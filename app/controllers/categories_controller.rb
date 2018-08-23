class CategoriesController < ApplicationController
  def show
    supergroup, *taxons = params[:category].split('/')
    supergroup = supergroup.underscore

    taxon = Taxon.find(File.join('/', *taxons))

    format_result = -> (result) do
      {
        link: {
          path: URI.join('https://gov.uk', result['link']).to_s,
          text: result['title'],
        }
      }
    end

    child_taxons = taxon.child_taxons.select do |child_taxon|
      Services
        .rummager
        .search_enum(count: 1,
                     filter_content_purpose_supergroup: supergroup,
                     filter_part_of_taxonomy_tree: Array(child_taxon.content_id))
        .count
        .positive?
    end

    documents = Services
                  .rummager
                  .search_enum(
                    fields: %w(title link taxons content_store_document_type public_timestamp),
                    reject_format: 'step_by_step_nav',
                    filter_content_purpose_supergroup: supergroup,
                    filter_part_of_taxonomy_tree: Array(taxon.content_id),
                    order: case supergroup
                           when 'news_and_communications'
                             '-public_timestamp'
                           else
                             nil
                           end
                  )

    step_by_step_navs = Services
                          .rummager
                          .search_enum(
                            fields: %w(title link),
                            filter_format: 'step_by_step_nav',
                            filter_part_of_taxonomy_tree: Array(taxon.content_id)
                          )
                          .map(&format_result)

    order = params[:order] || case supergroup
                              when 'services'
                                (documents.count > 20 ? 'a-z' : 'popularity')
                              else
                                'popularity'
                              end

    setup_content_item_and_navigation_helpers(taxon)

    render :show,
           locals: {
             taxon: TaxonPresenter.new(taxon),
             child_taxons: child_taxons,
             supergroup: supergroup,
             step_by_step_navs: step_by_step_navs,
             documents: documents,
             order: order,
           }
  end
end
