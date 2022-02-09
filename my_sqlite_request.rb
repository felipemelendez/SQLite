require 'csv'
require 'fileutils'
# require_relative './print_module'
%w[select insert update delete].each { |f| require_relative "crud_files/#{f}" }

class MySqliteRequest
  include Select
  include Insert
  include Update
  include Delete
  # include Print

  def initialize(table_name = nil)
    @type_of_request = :none
    @column_name = nil
    @select_columns = []
    @where_params = []
    @insert_attributes = {}
    @set_attributes = {}
    @table_name = table_name
    @table_name_2 = nil
    @join_params = []
    @order = :asc  # ascending order
  end

  def from(table_name) # table_name is also a filename
    @table_name = table_name
    self
  end

  def where(column_name, criteria) # During run() collect the columns sent as parameters to select
    @where_params << [column_name, criteria]
    self
  end

  def join(column_on_db_a, filename_db_b, column_on_db_b) # Implement a join method which will load another filename_db and will join both database on a on column.
    self._setTypeOfRequest(:join)
    @join_params << [column_on_db_a, column_on_db_b]
    @table_name_2 = filename_db_b
    self
  end

  def order(order, column_name) #  Implement an order method which will received two parameters, order (:asc or :desc) and column_name. It will sort depending on the order base on the column_name.
    self._setTypeOfRequest(:order)
    if order == "descending"
      @order = :desc
    elsif order == "ascending"
      @order = :asc
    end
    @column_name = column_name
    self
  end

  def values(data)
    if (@type_of_request == :insert)
      @insert_attributes = data
    else
      raise "Wrong type of request to call values()"
    end
    self
  end

  def set(data) # Set Implement a method to update which will receive data (a hash of data on format (key => value)). It will perform the update of attributes on all matching row. An update request might be associated with a where request.
    if (@type_of_request == :update)
      @set_attributes = data
    else
      raise "Wrong type of request to call set()"
    end
    self
  end

  def print_join_type
    puts "FROM file: #{@table_name_2}"
    puts "JOIN Attributes: #{@join_params}"
  end

  def print_order_type
    if @order == :asc
      puts "Ascending order"
    elsif @order == :desc
      puts "Descending order"
    end
    puts "Order by: #{@column_name}"
  end

  def print
    puts "Type of request: #{@type_of_request}"
    puts "Table name: #{@table_name}"
    if (@type_of_request == :select)
      print_select_type
    elsif (@type_of_request == :insert)
      print_insert_type
    elsif (@type_of_request == :delete)
      print_delete_type
    elsif (@type_of_request == :update)
      print_update_type
    elsif (@type_of_request == :join)
      print_join_type
    elsif (@type_of_request == :order)
      print_order_type
    end
  end

  def run
    print
    if (@type_of_request == :select)
      _run_select
    elsif (@type_of_request == :insert)
      _run_insert
    elsif (@type_of_request == :delete)
      _run_delete
    elsif (@type_of_request == :update)
      _run_update
    elsif (@type_of_request == :join)
      _run_join
    elsif (@type_of_request == :order)
      _run_order
    end
  end

  def _setTypeOfRequest(new_type)
    if (@type_of_request == :none or @type_of_request == new_type)
      @type_of_request = new_type
    else
      raise "Invalid: type of request already set to #{@type_of_request}. (new type => #{new_type})"
    end
  end

  def _run_join
    file_1 = []
    file_2 = []
    temp_arr = []
    CSV.open("test2.csv", "w") do |temp_csv|
      CSV.foreach(@table_name, 'r+', headers: true) do |row_f1|
        file_1 << row_f1.to_hash
      end
      CSV.foreach(@table_name_2, 'r', headers: true) do |row_f2|
        file_2 << row_f2.to_hash
      end
      file_1.each_with_index do |row_1, i|
        file_2.each_with_index do |row_2, j|
          if (row_1[@join_params[0][0]] == row_2[@join_params[0][1]])
            row_1.merge!(row_2)
          end
        end
        temp_arr << row_1
      end
      temp_csv << temp_arr[0].keys
      temp_arr.each do |row|
        temp_csv << row.values
      end
    end
    FileUtils.mv 'test2.csv', @table_name
  end

  def _run_order
    my_arr_of_hashes = []
    CSV.open("test2.csv", "w") do |temp_csv|
      CSV.foreach(@table_name, 'r', headers: true) do |row_f2|
        my_arr_of_hashes << row_f2.to_hash
      end
      if @order == :asc
        my_arr_of_hashes.sort! {|a,b| a["weight"] <=> b["weight"]}
      elsif @order == :desc
        my_arr_of_hashes.sort! {|a,b| b["weight"] <=> a["weight"]}
      end
      temp_csv << my_arr_of_hashes[0].keys
      my_arr_of_hashes.each do |row|
        temp_csv << row.values
      end
    end
    FileUtils.mv 'test2.csv', @table_name
  end

end

def _main();

  # request = MySqliteRequest.new

  # # SELECT tests
  # request = request.select('name')
  # request = request.from('./csv_files/nba_player_data.csv')
  # request = request.where('college', 'Georgia Institute of Technology')
  # # res = request.run
  # # request.print_table(res)
  # puts request.run

  # request = request.from('./csv_files/nba_player_data.csv')
  # request = request.select('name')
  # puts request.run

  # request = request.from('./csv_files/nba_player_data.csv')
  # request = request.select('name')
  # request = request.where('college', 'University of California')
  # request = request.where('year_start', '1997')
  # puts request.run

  # INSERT test
  # request = request.insert('./csv_files/nba_player_data_light.csv')
  # request = request.values({"name" => "Michael Jordan", "year_start" => "1985", "year_end" => "2003", "position" => "G-F", "height" => "6-6", "weight" => "195", "birth_date" => "February 17, 1963", "college" => "University of North Carolina"})
  # request.run

  # DELETE test
  # request = request.from('./csv_files/nba_player_data_light.csv')
  # request = request.delete
  # request = request.where('name', 'Tom Abernethy')
  # request.run

  # UPDATE test
  # request = request.update('./csv_files/nba_player_data_light.csv')
  # request = request.set({"weight" => "250", "college" => "Georgia Tech"})
  # request = request.where('name', 'Michael Jordan')
  # request.run

  # request = request.update('./csv_files/nba_player_data.csv')
  # request = request.set('name' => 'Alaa Renamed')
  # request = request.where('name', 'Alaa Abdelnaby')
  # request.run

  # JOIN test
  # request = request.from('./csv_files/nba_player_info.csv')
  # request = request.join('name', 'nba_player_stats.csv', 'player')
  # request.run

  # ORDER test
  # request = request.from('./csv_files/for_sort.csv')
  # request = request.order('ascending', 'year_end')
  # puts request.run


end

_main();

