require_relative "../minitest_to_rspec/convert_to_rspec.rb"

# example usage: bundle exec rake convert:to_rspec\["test/components","spec/views/components"\]
namespace :convert do
  desc "task to do some basic conversion of minitest syntax to rspec syntax"
  task :to_rspec, %i[minitest_folder rspec_folder] => [:environment] do |_, args|
    message = <<-MSG
      minitest_folder and rspec_folder args are required.
      Example usage: bundle exec rake convert:to_rspec\\["test/components","spec/views/components"\\]
    MSG
    raise message unless args[:minitest_folder] && args[:rspec_folder]

    converter = ConvertToRspec.new(args.minitest_folder, args.rspec_folder)
    converter.go!
  end
end
