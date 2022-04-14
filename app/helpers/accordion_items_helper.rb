module AccordionItemsHelper
  def accordion_items(accordion_contents, section={})
    section_contents = {
      heading: {
        text: section[:title],
      },
      content: {
        html: section[:contents],
      },
      data_attributes: section[:data_attributes]
    }

    accordion_contents << section_contents
  end
end
