module Update

  def update(table_name) # Update Implement a method to update which will receive a table name (filename). It will continue to build the request. An update request might be associated with a where request.
    self._setTypeOfRequest(:update)
    @table_name = table_name
    self
  end

  def print_update_type
    puts "SET Attributes: #{@set_attributes}"
    puts "WHERE Attributes: #{@where_params}"
  end

  def _run_update # update fields in row of file
    temp_arr = []
    File.open('file.txt.tmp', 'w') do |f2|
      CSV.open(@table_name, 'r', headers: true) do |file|
        file.each do |line|
          if line[@where_params[0][0]] == @where_params[0][1]
            @set_attributes.each do |key, value|
              line[key] = value
            end
          end
          temp_arr << line.to_hash
        end
        f2 << temp_arr[0].keys.join(', ')
        f2 << "\n"
        temp_arr.each do |row|
          f2 << row.values.join(', ')
          f2 << "\n"
        end
      end
    end
    FileUtils.mv 'file.txt.tmp', @table_name
  end
end