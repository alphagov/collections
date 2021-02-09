# Whilst collections has two test suites (minitest and rspec) we need to
# patch the minitest assertions for the cucumber feature tests to pass.
# Without this patch, the feature tests error with "undefined method `+' for nil:NilClass (NoMethodError)"
# each time assert is called eg assert page.has_text?("Foo").

require "minitest"

module MiniTestAssertions
  def self.extended(base)
    base.extend(MiniTest::Assertions)
    base.assertions = 0
  end

  attr_accessor :assertions
end

World(MiniTestAssertions)
