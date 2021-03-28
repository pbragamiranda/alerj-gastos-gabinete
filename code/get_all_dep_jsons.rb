require 'pry'
require 'csv'
require 'json'
require 'open-uri'

dep_ids = []

dep_info_fp = './data/csv_data/dep_info.csv'
csv_options = { headers: :first_row, header_converters: :symbol }

CSV.foreach(dep_info_fp, csv_options) do |row|
  dep_ids << row[:congressman_id].to_i
end

dep_ids.each do |id|
  url  = "https://docigp.alerj.rj.gov.br/api/v1/congressmen/#{id}/budgets?query=%7B%22filter%22:%7B%22text%22:null,%22checkboxes%22:%7B%22filler%22:false%7D,%22selects%22:%7B%22filler%22:false%7D%7D,%22pagination%22:%7B%22total%22:11,%22per_page%22:%22250%22,%22current_page%22:1,%22last_page%22:2,%22from%22:1,%22to%22:10,%22pages%22:[1,2]%7D%7D"
  doc  = open(url).read
  data = JSON.parse(doc)['data']
  filename = data[0]['congressman_legislature']['congressman']['name']

  File.write("./data/json_data/dep_entries/#{filename}.json", JSON.pretty_generate(data))

  puts("#{filename}'s records saved.")
end

