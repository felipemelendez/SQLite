require 'csv'
require 'readline'
require 'optparse'
Dir["./crud_files/*.rb"].each {|sqlite_file| require sqlite_file }
require_relative 'my_sqlite_request.rb'

$nba_players_data_table = './csv_files/nba_player_data.csv'
$nba_player_info = './csv_files/nba_player_info.csv'
$nba_player_stats = './csv_files/nba_player_stats.csv'

#==========
#  SELECT
#==========

def select_query(request) # with order
    request.select('*')
    request.from($nba_players_data_table)
    request.select(['birth_city', 'college'])
    # request = request.where('college', 'Georgia Institute of Technology')
    # request.where('birth_date', 'June 24, 1968')    # ===> OPTIONAL
    # request.order('asc', 'name')
    request.run
end

def select_join_query(request) # join
    request.from($nba_player_info)
    request.join('name', $nba_player_stats, 'player')
    request.run
end

#==========
# UPDATE
#==========

def update_query(request)
    request.update($nba_players_data_table)
    data = {"weight" => "250", "college" => "Georgia Tech"}
    request.where('name', 'Michael Jordan')
    request.set(data)
    request.run
end

#==========
# INSERT
#==========

def insert_query(request)
    request.insert($nba_players_data_table)
    vals = {"name" => "Michael Jordan", "year_start" => "1985", "year_end" => "2003", "position" => "G-F", "height" => "6-6", "weight" => "195", "birth_date" => "February 17, 1963", "college" => "University of North Carolina"}
    request.values(vals)
    request.run
end

#==========
# DELETE
#==========

def delete_query(request)
    request.delete # delete the whole table
    request.from($nba_players_data_table)
    request.where('name', 'Tom Abernethy')
    request.run
end


def main()
    request = MySqliteRequest.new
    # select_query(request)
    # select_join_query(request)
    # update_query(request)
    # insert_query(request)
    # delete_query(request)
end

main()