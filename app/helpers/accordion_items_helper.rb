module AccordionItemsHelper
  def accordion_items(section_title:, section_contents:, accordion_contents:)
    section_contents = {
      heading: {
        text: section_title,
      },
      content: {
        html: section_contents,
      },
    }
    accordion_contents << section_contents
  end
end
