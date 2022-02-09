# Command Line Interface (CLI) to your MySqlite class
require "readline"
require_relative "my_sqlite_request"

$nba_players_data_table = './csv_files/nba_player_data.csv'
$nba_player_info = './csv_files/nba_player_info.csv'
$nba_player_stats = './csv_files/nba_player_stats.csv'

class MySqliteQueryCli
  def initialize
    @request = MySqliteRequest.new
    @all_sql_cmd = ["SELECT", "UPDATE", "INSERT", "DELETE", "FROM", "WHERE", "JOIN", "ORDER", "SET", "VALUES", "INTO"]
    @update_cmds = ["UPDATE", "SET", "WHERE"]
    @insert_cmds = ["INSERT", "INTO", "VALUES"]
    @delete_cmds = ["DELETE", "FROM", "WHERE"]
  end

  def if_quit(query)
    if query.include?("quit")
      exit!
    end
  end

  def run!
    while buf = Readline.readline(">", true) # this is what reads the command line
      parse(buf)
    end
  end

  def parse(buf)
      query = buf.split
      if_quit(query)

      if (buf =~/SELECT (\*|([a-z]\w*, *)*[a-z]\w*) FROM ([a-z]\w*);/i)
        columns, table = $1, $3
        columns = columns.split(/, */)
        table = './csv_files/' + table + '.csv'
        @request = @request.select(columns)
        @request = @request.from(table)
        @request.run

      elsif (buf =~/SELECT (\*|([a-z]\w*, *)*[a-z]\w*) FROM ([a-z]\w*) WHERE (([a-z]\w*)=\'(.*?)*\');/i)
        columns, table, where = $1, $3, $4
        columns = columns.split(/, */)
        table = './csv_files/' + table + '.csv'
        where = where.split(/= */)
        where_key = where[0]
        where_value = where[1].delete_prefix("'").delete_suffix("'")
        @request = @request.select(columns)
        @request = @request.from(table)
        @request = @request.where(where_key, where_value)
        @request.run

      elsif (buf =~/INSERT INTO ([a-z]\w*) VALUES \((.*)\);/i)
        p $1
        p $2
        p $2.split(/, */)

      elsif query[0].upcase == "UPDATE"
        p "ACTIVATED UPDATE"
      elsif query[0].upcase == "INSERT"
        p "ACTIVATED INSERT"
      elsif query[0].upcase == "DELETE"
        p "ACTIVATED DELETE"
      else
        raise "INVALID COMMAND, PLEASE USE SELECT, UPDATE, INSERT, and/or DELETE"
      end
    end
  end



cli = MySqliteQueryCli.new
# # cli.parse("INSERT INTO students VALUES (John, john@johndoe.com, A, https://blog.johndoe.com);")
cli.parse("SELECT name FROM nba_player_data;")
# cli.parse("SELECT name FROM nba_player_data WHERE college='Georgia Institute of Technology';")
# cli.run!



