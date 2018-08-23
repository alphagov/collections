module CategoryHelper
  def link_to_supergroup(supergroup, organisation:, taxon:, order: nil)
    organisation_param = organisation&.base_path&.split('/')&.last
    taxon_param = taxon.base_path[1..-1]

    supergroup_param = supergroup.parameterize
    supergroup_param = nil if supergroup_param == 'all'

    category_params = [organisation_param, supergroup_param, taxon_param].reject(&:blank?)

    link_to supergroup, category_path(category: category_params, order: order)
  end
end
