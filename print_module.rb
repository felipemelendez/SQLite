module Print
  def print_table(res)
    # res.map {|row| p row}

    data = res.map(&:values)
    headers = res.map(&:keys).uniq[0]
    # find each column width
    col_width = []
    headers.each { |header| col_width << header.size }

    data.each do |row|
      row.each_with_index do |value, i|
        if value.nil?
          col_width[i] = 5 if col_width[i] < 5
        elsif col_width[i] < value.size
          col_width[i] = value.size
        end
      end
    end
    width = col_width.reduce(:+)
    print ' '+'-'width + "\n"
    print_row(headers, col_width)
    print ' '+'-'width + "\n"
    data.each {|row| print_row(row, col_width)}
    print ' '+'-'width + "\n"

    puts "(#{data.size} rows)"
  end
  # print the output
  def print_row(row, col_width)
    row.each_with_index do |val, i|
      print "|"
      if val.nil?
        print ''
        print " "(col_width[i]-4)
      else
        print val
        res = (col_width[i]-val.length)
        res = 1 if res < 0
        print " "* res
      end
    end
    print "|\n"
  end
end