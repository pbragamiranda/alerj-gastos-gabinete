require 'pry'
require 'csv'
require 'json'
require 'open-uri'

congressmen_budget_pair = []

entries_fp = './data/csv_data/entries.csv'
csv_options = { headers: :first_row, header_converters: :symbol }

CSV.foreach(entries_fp, csv_options) do |row|
  pair = []
  pair << row[:congressman_id].to_i
  pair << row[:budget_id].to_i
  congressmen_budget_pair << pair
end

# congressmen_budget_pair.uniq.each do |id, budget|
#   p id
#   p budget
# end

congressmen_budget_pair.uniq.each do |deputy, budget|
  url  = "https://docigp.alerj.rj.gov.br/api/v1/congressmen/#{deputy}/budgets/#{budget}/entries?query=%7B%22filter%22:%7B%22text%22:null,%22checkboxes%22:%7B%22filler%22:false%7D,%22selects%22:%7B%22filler%22:false%7D%7D,%22pagination%22:%7B%22total%22:6,%22per_page%22:%22250%22,%22current_page%22:1,%22last_page%22:1,%22from%22:1,%22to%22:6,%22pages%22:[1]%7D%7D"
  doc  = open(url).read
  data = JSON.parse(doc)['data']
  filename = "#{deputy}#{'-'}#{budget}"

  File.write("./data/json_data/entries_info/#{filename}.json", JSON.pretty_generate(data))

  puts("#{filename}'s records saved.")
end
