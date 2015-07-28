require 'csv'
require 'json'
require 'pp'

def rummager_type(type, legacy_type)
  if type == "MainstreamBrowsePage"
    "filter_mainstream_browse_pages[]"
  else
    "filter_#{legacy_type}s[]"
  end
end

namespace :comparison do
  desc "report on differences between rummager and contentapi"
  # from local collections-publisher db, ran in rails console:
  #
  # require 'csv'
  # CSV.open("tags.csv", "w") do |csv|
  #   Tag.all.map { |t|
  #     [t.type,t.legacy_tag_type,t.full_slug]
  #   }.each { |r|
  #     csv << r
  #   }
  # end
  task :run => :environment do
    cs, rs = [], []
    CSV.foreach("lib/tasks/tags.csv") do |type, legacy_type, full_slug|
      rummager_data = `curl http://rummager.dev.gov.uk/unified_search.json?q=#{full_slug}&#{rummager_type(type, legacy_type)}=#{full_slug}`
      contentapi_data =  `curl http://contentapi.dev.gov.uk/with_tag.json?#{legacy_type}=#{full_slug}`

      rummager_results = JSON.parse(rummager_data)["results"]
      contentapi_results = JSON.parse(contentapi_data)["results"]

      if rummager_results.present?
        rummager_results.each do |r|
          if contentapi_results.nil?
            rs << [full_slug,r["title"],r["link"]]
          elsif !contentapi_results.any? { |c| c["web_url"].include?(r["link"]) }
            rs << [full_slug,r["title"],r["link"]]
          end
        end
      end

      if contentapi_results.present?
        contentapi_results.each do |c|
          if rummager_results.nil?
            cs << [full_slug,c["title"], c["web_url"]]
          elsif !rummager_results.any? { |r| c["web_url"].include?(r["link"]) }
            cs << [full_slug,c["title"], c["web_url"]]
          end
        end
      end
    end

    File.open("rummager-contentapi-differences.csv","w") do |f|
      f.puts "In Rummager not Contentapi"
      rs.group_by {|r| r[0] }.each do |r|
        f.puts r[0]
        r[1].each do |full_slug, title, link|
          f.puts ",#{title},#{link}"
        end
      end
      f.puts "\nIn Contentapi not Rummager"
      cs.group_by {|c| c[0] }.each do |c|
        f.puts c[0]
        c[1].each do |full_slug, title, url|
          f.puts ",#{title},#{url}"
        end
      end
    end
  end
end
