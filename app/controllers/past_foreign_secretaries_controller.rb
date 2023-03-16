class PastForeignSecretariesController < ApplicationController
  def index
    content_item = YAML.load_file(Rails.root.join("config/past_foreign_secretaries/content_item.yml"))
    @index_page = HistoricAppointmentsIndex.new(ContentItem.new(content_item))
    setup_content_item_and_navigation_helpers(@index_page)

    @selection_of_profiles =
      [
        {
          title: "Edward Frederick Lindley Wood, Viscount Halifax",
          href: "/government/history/past-foreign-secretaries/edward-wood",
          image_src: "history/past-foreign-secretaries/viscount-halifax.jpg",
          heading_text: "Edward Frederick Lindley Wood, Viscount Halifax",
          service: ["1938 to 1940"],
        },
        {
          title: "Sir Austen Chamberlain",
          href: "/government/history/past-foreign-secretaries/austen-chamberlain",
          image_src: "history/past-foreign-secretaries/austen-chamberlain.jpg",
          heading_text: "Sir Austen Chamberlain",
          service: ["1924 to 1929"],
        },
        {
          title: "George Nathaniel Curzon, Marquess of Kedleston",
          href: "/government/history/past-foreign-secretaries/george-curzon",
          image_src: "history/past-foreign-secretaries/george-nathaniel-curzon.jpg",
          heading_text: "George Nathaniel Curzon, Marquess of Kedleston",
          service: ["1919 to 1924"],
        },
        {
          title: "Sir Edward Grey, Viscount Grey of Fallodon",
          href: "/government/history/past-foreign-secretaries/edward-grey",
          image_src: "history/past-foreign-secretaries/sir-edward-grey.jpg",
          heading_text: "Sir Edward Grey, Viscount Grey of Fallodon",
          service: ["1905 to 1916"],
        },
        {
          title: "Henry Petty-Fitzmaurice, Marquess of Lansdowne",
          href: "/government/history/past-foreign-secretaries/henry-petty-fitzmaurice",
          image_src: "history/past-foreign-secretaries/lord-landsowne.jpg",
          heading_text: "Henry Petty-Fitzmaurice, Marquess of Lansdowne",
          service: ["1900 to 1905"],
        },
        {
          title: "Robert Cecil, Marquess of Salisbury",
          href: "/government/history/past-foreign-secretaries/robert-cecil",
          image_src: "history/past-foreign-secretaries/marquess-of-salisbury.jpg",
          heading_text: "Robert Cecil, Marquess of Salisbury",
          service: ["1878 to 1880", "1885 to 1886", "1887 to 1892", "and 1895 to 1900"],
        },
        {
          title: "George Leveson Gower, Earl Granville",
          href: "/government/history/past-foreign-secretaries/george-gower",
          image_src: "history/past-foreign-secretaries/earl-granville.jpg",
          heading_text: "George Leveson Gower, Earl Granville",
          service: ["1851 to 1852", "1870 to 1874", "and 1880 to 1885"],
        },
        {
          title: "George Hamilton Gordon, Earl of Aberdeen",
          href: "/government/history/past-foreign-secretaries/george-gordon",
          image_src: "history/past-foreign-secretaries/lord-aberdeen.jpg",
          heading_text: "George Hamilton Gordon, Earl of Aberdeen",
          service: ["1828 to 1830", "and 1841 to 1846"],
        },
        {
          title: "Charles James Fox",
          href: "/government/history/past-foreign-secretaries/charles-fox",
          image_src: "history/past-foreign-secretaries/charles-james-fox.jpg",
          heading_text: "Charles James Fox",
          service: ["1782", "1783", "and 1806"],
        },
        {
          title: "William Wyndham Grenville, Lord Grenville",
          href: "/government/history/past-foreign-secretaries/william-grenville",
          image_src: "history/past-foreign-secretaries/lord-grenville.jpg",
          heading_text: "William Wyndham Grenville, Lord Grenville",
          service: ["1791 to 1801"],
        },
      ]
  end

  def show
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path.split("/")[0...-1].join("/")))

    if people_with_individual_pages.include?(params[:id])
      render template: "past_foreign_secretaries/#{params[:id].underscore}"
    else
      render plain: "Not found", status: :not_found
    end
  end

private

  def people_with_individual_pages
    %w[
      austen-chamberlain
      charles-fox
      edward-grey
      edward-wood
      george-curzon
      george-gordon
      george-gower
      henry-petty-fitzmaurice
      robert-cecil
      william-grenville
    ]
  end
end
