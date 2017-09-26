require 'component_test_helper'

class TopicListTest < ComponentTestCase
  def component_name
    "topic-list"
  end

  test "renders nothing without a list of items" do
    assert_empty render_component({})
  end

  test "renders a list of links" do
    render_component(items: [{ path: '/path', text: 'Text' }])
    assert_select ".app-c-topic-list__link[href='/path']", text: 'Text'
  end

  test "renders links with data attributes" do
    render_component(items: [
                              {
                                path: '/path',
                                text: 'Text',
                                data_attributes: {
                                  test: 'test'
                                }
                              }
                            ])

    assert_select ".app-c-topic-list__link[data-test='test']"
  end

  test "renders a see more link" do
    see_more_link = {
                      path: '/more',
                      text: 'More',
                      data_attributes: { test: 'test' }
                    }

    items = [
              {
                path: '/path',
                text: 'Text'
              }
            ]


    render_component(items: items, see_more_link: see_more_link)
    assert_select ".app-c-topic-list__item a[href='/more'][data-test='test']", text: 'More'
  end
end
