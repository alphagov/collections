# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks

  vendored_cucumber_bin = Dir[Rails.root.join("vendor/{gems,plugins}/cucumber*/bin/cucumber")].first
  $LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + "/../lib") unless vendored_cucumber_bin.nil?

  begin
    require "cucumber/rake/task"

    namespace :cucumber do
      Cucumber::Rake::Task.new({ ok: "test:prepare" }, "Run features that should pass") do |t|
        t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
        t.fork = true # You may get faster startup if you set this to false
        t.profile = "default"
      end

      Cucumber::Rake::Task.new({ wip: "test:prepare" }, "Run features that are being worked on") do |t|
        t.binary = vendored_cucumber_bin
        t.fork = true # You may get faster startup if you set this to false
        t.profile = "wip"
      end

      Cucumber::Rake::Task.new({ rerun: "test:prepare" }, "Record failing features and run only them if any exist") do |t|
        t.binary = vendored_cucumber_bin
        t.fork = true # You may get faster startup if you set this to false
        t.profile = "rerun"
      end
    end
    desc "Alias for cucumber:ok"
    task cucumber: "cucumber:ok"

    task default: :cucumber
  rescue LoadError
    desc "cucumber rake task not available (cucumber not installed)"
  end
end
