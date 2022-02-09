module Insert

  def insert(table_name)
    self._setTypeOfRequest(:insert)
    @table_name = table_name
    self
  end

  def print_insert_type
    puts "INSERT Attributes: #{@insert_attributes}"
  end

  def _run_insert  # appending to the end of the file
    File.open(@table_name, 'a') do |file|  # opening the file in append mode (and storing it as variable 'file')
      file.puts @insert_attributes.values.join(',')
    end # this closes the file
  end

end