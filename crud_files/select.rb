module Select

  # COMMAND

  def select(columns)
    if (columns.is_a?(Array))
      @select_columns += columns.collect { |elem| elem.to_s } # convert to string in case input is a number (like an id)
    else
      @select_columns << columns.to_s
    end
    self._setTypeOfRequest(:select)
    self
  end

  def print_select_type
    puts "SELECT Attributes: #{@select_columns}"
    puts "WHERE Attributes: #{@where_params}"
  end

  def _run_select
    result = []
    if (@where_params.empty?)
      CSV.parse(File.read(@table_name), headers: true).each do |row|
          result << row.to_hash.slice(*@select_columns)
      end
    elsif (@where_params.length() == 1)
      CSV.parse(File.read(@table_name), headers: true).each do |row|
        if row[@where_params[0][0]] == @where_params[0][1]
          result << row.to_hash.slice(*@select_columns)
        end
      end
    else
      CSV.parse(File.read(@table_name), headers: true).each do |row|
        if (row[@where_params[0][0]] == @where_params[0][1] && row[@where_params[1][0]] == @where_params[1][1])
          result << row.to_hash.slice(*@select_columns)
        end
      end
    end
    result
  end
end