require 'csv'
require 'json'

filepath = './data/json_data/dep_info.json'

json_file = File.read(filepath)

dep_info = JSON.parse(json_file)['data']

dep_hashes = []

dep_info.each do |deputy|
  new_deputy = {}
  new_deputy['congressman_id'] = deputy['user']['congressman_id']
  new_deputy['name'] = deputy['name']
  new_deputy['nickname'] = deputy['nickname']
  new_deputy['email'] = deputy['user']['email']
  new_deputy['party_id'] = deputy['party']['id']
  new_deputy['party_code'] = deputy['party']['code']
  new_deputy['party_name'] = deputy['party']['name']
  dep_hashes << new_deputy
end

csv_filepath = './data/csv_data/dep_info.csv'
csv_options  = { col_sep: ',', force_quotes: true, quote_char: '"' }

CSV.open(csv_filepath, 'wb', csv_options) do |csv|
  csv << dep_hashes.first.keys
  dep_hashes.each do |deputy|
    csv << deputy.values
   end
end
