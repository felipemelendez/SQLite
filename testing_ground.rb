@all_sql_cmd = ["SELECT", "UPDATE", "INSERT", "DELETE", "FROM", "WHERE", "JOIN", "ORDER", "SET", "VALUES", "INTO"]
@update_cmds = ["UPDATE", "SET", "WHERE"]
@insert_cmds = ["INSERT", "INTO", "VALUES"]
@delete_cmds = ["DELETE", "FROM", "WHERE"]

#==============
# SQL_CLI FUNCS
#==============

def command_count(input_arr)
  result = {}
  input_arr.each do |element, idx|
      if @all_sql_cmd.include?(element.upcase)
          if result[element.upcase]
              result[element.upcase] += 1
          else
              result[element.upcase] = 1
          end
      end
  end

  if result.empty?
      return false
  else
      return result
  end
end

p command_count(["SELECT", "*", "FROM", "WHERE", "WHERE"])
# p command_count(["name", "*", "database"])