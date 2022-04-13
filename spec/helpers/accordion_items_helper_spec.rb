RSpec.describe AccordionItemsHelper do
  include AccordionItemsHelper

  accordion_contents = []

  content = "<p>Some content</p>"

  let(:result) do
    accordion_items(section_title: "More on this topic", section_contents: content, accordion_contents: accordion_contents)
  end

  let(:expected) do
    [{
      heading: {
        text: "More on this topic",
      },
      content: {
        html: "<p>Some content</p>",
      },
    }]
  end

  it "provides the content in the format expected by the accordion component" do
    expect(result).to eq(expected)
  end
end
