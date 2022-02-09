require 'test/unit'
require_relative 'my_readline'

class ReadlineTests < Test::Unit::TestCase

  def test_select_one_column
    cli = MySqliteQueryCli.new
    actual_output = cli.parse("SELECT name FROM for_test;")
    puts "actual output = #{actual_output}"
    expected_output = [{"name"=>"Tom Abernethy"}, {"name"=>"Michael Jordan"}]
    assert_equal(expected_output, actual_output)
  end

  def test_select_two_columns
    cli = MySqliteQueryCli.new
    actual_output = cli.parse("SELECT name, college FROM for_test;")
    puts "actual output = #{actual_output}"
    expected_output = [{"college"=>"Indiana University", "name"=>"Tom Abernethy"},
      {"college"=>"University of North Carolina", "name"=>"Michael Jordan"}]
    assert_equal(expected_output, actual_output)
  end

  def test_select_where_no_results
    cli = MySqliteQueryCli.new
    actual_output = cli.parse("SELECT name FROM for_test WHERE college='Georgia Tech';")
    puts "actual output = #{actual_output}"
    expected_output = []
    assert_equal(expected_output, actual_output)
  end

  def test_select_where_one_result
    cli = MySqliteQueryCli.new
    actual_output = cli.parse("SELECT name FROM for_test WHERE college='Indiana University';")
    puts "actual output = #{actual_output}"
    expected_output = [{"name"=>"Tom Abernethy"}]
    assert_equal(expected_output, actual_output)
  end

  def test_select_where_syntax_error
    cli = MySqliteQueryCli.new
    error = assert_raises do # this is a type of rescue
      actual_output = cli.parse("SELECT name FROM for_test WHERE college=synax_error;")
    end
    assert_equal("INVALID COMMAND, PLEASE USE SELECT, UPDATE, INSERT, and/or DELETE", error.to_s)
  end

  # def test_fail
  #   assert(false, 'Assertion was false.')
  # end
end