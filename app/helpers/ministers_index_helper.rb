module MinistersIndexHelper
  def role_link(role)
    link_to role.title, role.url, class: "govuk-link"
  end

  def cabinet_minister_description(minister)
    list_of_roles = joined_list(minister.roles.map { |role| role_link(role) }).html_safe
    footnotes = tag.span(minister.role_payment_info.join(". "), class: "footnotes")

    if minister.role_payment_info.any?
      content_tag(:p, safe_join([list_of_roles, footnotes]))
    else
      content_tag(:p, list_of_roles)
    end
  end
end
