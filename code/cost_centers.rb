require 'csv'
require 'json'

filepath = './data/json_data/cost_center.json'

json_file = File.read(filepath)

dep_info = JSON.parse(json_file)['data']

cost_centers = []

dep_info.each do |center|
  new_center = {}
  new_center['id'] = center['id']
  new_center['code'] = center['code']
  new_center['parent_code'] = center['parent_code']
  new_center['name'] = center['name']
  new_center['frequency'] = center['frequency']
  cost_centers << new_center
end

csv_filepath = './data/csv_data/cost_centers.csv'
csv_options  = { col_sep: ',', force_quotes: true, quote_char: '"' }

CSV.open(csv_filepath, 'wb', csv_options) do |csv|
  csv << cost_centers.first.keys
  cost_centers.each do |deputy|
    csv << deputy.values
   end
end
