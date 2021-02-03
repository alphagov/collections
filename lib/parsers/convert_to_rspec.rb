# Taken from https://gist.github.com/seven1m/e375bcdf2864da0022f1

require "parser/current"
require "unparser"
require "fileutils"

class ConvertToRspec
  attr_reader :minitest_folder, :rspec_folder

  def initialize(minitest_folder, rspec_folder)
    @minitest_folder = minitest_folder
    @rspec_folder = rspec_folder
  end

  def go!
    Dir["#{minitest_folder}/*_test.rb"].each do |test|
      puts test
      body = File.read(test)
      test.gsub!(minitest_folder.to_s, rspec_folder.to_s)
      new_path = test.gsub!(/_test\.rb$/, "_spec.rb")
      # custom_fixes_before!(body, new_path)
      describe!(body)
      before!(body)
      context_to_describe!(body)
      should_to_it!(body)
      test_to_it!(body)
      assert_question!(body)
      assert_cannot!(body)
      assert_can!(body)
      assert_equal!(body)
      assert_empty!(body)
      assert_include!(body)
      assert_match!(body)
      assert_response!(body)
      assert_redirected_to!(body)
      assert_nil!(body)
      assert_not!(body)
      assert!(body)
      custom_fixes_after!(body, new_path)
      FileUtils.mkdir_p(rspec_folder)
      File.open(new_path, "w") { |f| f.write(body) }
      puts
    end
  end

  def describe!(body)
    replace_line!(body) do |line|
      if line =~ /class ([:\w]+)Test < .*::(TestCase|IntegrationTest)\s*$/
        "describe #{Regexp.last_match(1)} do"
      end
      if line =~ / ([:\w]+) < ComponentTestCase/
        "describe #{Regexp.last_match(1)} do"
      end
    end
  end

  def before!(body)
    replace_line!(body) do |line|
      if line =~ /(\s*)(setup do|def setup)/
        "#{Regexp.last_match(1)}before do"
      end
    end
  end

  def context_to_describe!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)context (['"])(\w+)(['"]) do\s*$/
        "#{Regexp.last_match(1)}describe #{Regexp.last_match(2)}#{Regexp.last_match(3)}#{Regexp.last_match(4)} do"
      end
    end
  end

  def should_to_it!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)should (['"])(.*)(['"]) do\s*$/
        "#{Regexp.last_match(1)}it #{Regexp.last_match(2)}should #{Regexp.last_match(3)}#{Regexp.last_match(4)} do"
      end
    end
  end

  def test_to_it!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)test (['"])(.*)(['"]) do\s*$/
        "#{Regexp.last_match(1)}it #{Regexp.last_match(2)}#{Regexp.last_match(3)}#{Regexp.last_match(4)} do"
      end
    end
  end

  def assert_question!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert (\!|not )(.*)\.(\w+)\?\s*$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(3)}).to_not be_#{Regexp.last_match(4)}"
      elsif line =~ /^(\s*)assert (.*)\.(\w+)\?\s*$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(2)}).to be_#{Regexp.last_match(3)}"
      end
    end
  end

  def assert_equal!(body)
    body.gsub!(/assert_equal(.*),\s*\n(.*)$/, "assert_equal\\1, \\2")
    replace_line!(body) do |line|
      if line =~ /^(\s*)(assert_equal.*)$/
        (arg1, arg2) = get_args(line)
        "#{Regexp.last_match(1)}expect(#{arg2}).to eq(#{arg1})"
      end
    end
  end

  def assert_cannot!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)(assert_cannot.*)$/
        (arg1, arg2, arg3) = get_args(line)
        "#{Regexp.last_match(1)}expect(#{arg1}).to_not be_able_to(#{arg2}, #{arg3})"
      end
    end
  end

  def assert_can!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)(assert_can.*)$/
        (arg1, arg2, arg3) = get_args(line)
        "#{Regexp.last_match(1)}expect(#{arg1}).to be_able_to(#{arg2}, #{arg3})"
      end
    end
  end

  def assert_include!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert (!|not )?(.*)\.include\?\((.*)\)$/
        negate = Regexp.last_match(2) ? "_not" : ""
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(3)}).to#{negate} include(#{Regexp.last_match(4)})"
      end
    end
  end

  def assert_match!(body)
    body.gsub!(/assert_match(.*),\s*\n(.*)$/, "assert_match\\1, \\2")
    replace_line!(body) do |line|
      if line =~ /^(\s*)(assert_match.*)$/
        (arg1, arg2) = get_args(line)
        "#{Regexp.last_match(1)}expect(#{arg2}).to match(#{arg1})"
      end
    end
  end

  def assert_response!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert_response :(.*)$/
        "#{Regexp.last_match(1)}expect(response).to be_#{Regexp.last_match(2)}"
      end
    end
  end

  def assert_redirected_to!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert_redirected_to (.*)$/
        "#{Regexp.last_match(1)}expect(response).to redirect_to(#{Regexp.last_match(2)})"
      end
    end
  end

  def assert_nil!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert_nil (.*)$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(2)}).to be_nil"
      end
    end
  end

  def assert_empty!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert_empty (.*)$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(2)}).to be_empty"
      end
    end
  end

  def assert_not!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert (!|not )(.*)\s*$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(3)}).not_to be"
      end
    end
  end

  def assert!(body)
    replace_line!(body) do |line|
      if line =~ /^(\s*)assert (.*)\s*$/
        "#{Regexp.last_match(1)}expect(#{Regexp.last_match(2)}).to be"
      end
    end
  end

  def replace_line!(body)
    lines = body.split(/\n/)
    lines.each_with_index do |line, index|
      begin
        new_line = yield(line, index)
      rescue StandardError
        puts "----------------------------------------"
        puts "line number #{index + 1}:"
        puts line.strip
        puts "----------------------------------------"
        raise
      end
      lines[index] = new_line if new_line
    end
    body.replace(lines.join("\n"))
  end

  # custom fixes to be run _after_ all the transformations
  def custom_fixes_after!(body, path); end

  def get_args(line)
    ast = Parser::CurrentRuby.parse(line)
    args = ast.to_a[2..-1]
    args.map { |a| Unparser.unparse(a) }
  end
end
