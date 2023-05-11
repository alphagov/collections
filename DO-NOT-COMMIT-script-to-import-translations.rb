require 'yaml'

root = '/home/chrisroos/govuk'
Dir[root + '/collections/config/locales/**'].each do |dir|
  locale = File.basename(dir)

  whitehall_locale_file = root + '/whitehall/config/locales/' + locale + '.yml'
  hash = YAML.load(File.read(whitehall_locale_file))
  translation = hash[locale]['organisation']['embassies']['find_an_embassy_title']

  output_locale_file = dir + '/embassies.yml'
  output = {
    locale => {
      'embassies' => {
        'index_title' => translation
      }
    }
  }
  File.open(output_locale_file, 'w') { |f| f.puts(output.to_yaml) }
end