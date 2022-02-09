module Delete

  # COMMAND

  def delete # set the request to delete on all matching rows. A delete request might be associated with a where request.
    self._setTypeOfRequest(:delete)
    self
  end

  def print_delete_type
    puts "DELETE FROM: #{@where_params}"
  end

  def _run_delete  # delete row of file
    open(@table_name, 'r') do |file|
      open('file.txt.tmp', 'w') do |f2|
        file.each_line do |line|
          f2.write line unless (line.include? @where_params[0][1])
        end
      end
    end
    FileUtils.mv 'file.txt.tmp', @table_name
  end
end