require 'pry'
require 'csv'
require 'json'
require 'open-uri'

# filepath = './data/data-structure.json'

# json_file = File.read(filepath)
# data = JSON.parse(json_file)['data']

# month -> data[0]['month']

# dep_ids = []

# dep_info_fp = './data/csv_data/dep_info.csv'
# csv_options = { headers: :first_row, header_converters: :symbol }

# CSV.foreach(dep_info_fp, csv_options) do |row|
#   dep_ids << row[:congressman_id].to_i
# end

entries = []

Dir.glob('./data/json_data/dep_entries/*.json') do |file|

  doc  = open(file).read
  data = JSON.parse(doc)

  range_entries = (0...data.size)

  range_pair = []
  range_entries.each do |entry|
    entries_per_month = (0...data[entry]['entries'].size)
    entries_per_month.each do |number|
      range_pair << [entry, number]
    end
  end

  range_pair.each do |e, n|
    new_entry = {}
    new_entry['congressman_id']        = data.dig(0, 'congressman_legislature_id')
    new_entry['congressman_entry_id']  = data.dig(e, 'entries', n, 'id')
    new_entry['budget_id']             = data.dig(e, 'entries', n, 'congressman_budget_id')
    new_entry['date']                  = data.dig(e, 'entries', n, 'date')
    new_entry['value']                 = data.dig(e, 'entries', n, 'value')
    new_entry['object']                = data.dig(e, 'entries', n, 'object')
    new_entry['to']                    = data.dig(e, 'entries', n, 'to')
    new_entry['cost_center_id']        = data.dig(e, 'entries', n, 'cost_center_id')
    new_entry['cost_center_name']      = data.dig(e, 'entries', n, 'cost_center', 'name')
    new_entry['cost_center_code']      = data.dig(e, 'entries', n, 'cost_center', 'code')
    new_entry['parent_code']           = data.dig(e, 'entries', n, 'cost_center', 'parent_code')
    entries << new_entry
  end
end

csv_filepath = './data/csv_data/entries.csv'
csv_save_options  = { col_sep: ',', force_quotes: true, quote_char: '"' }

CSV.open(csv_filepath, 'wb', csv_save_options) do |csv|
  csv << entries.first.keys
  entries.each do |entry|
    csv << entry.values
   end
end
