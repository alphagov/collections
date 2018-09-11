module SearchHelper
  def contents_list(taxon)
    list = []
    taxons.each do |taxon|
      list << { href: taxon.href, text: taxon.title }
    end
    list
  end
end