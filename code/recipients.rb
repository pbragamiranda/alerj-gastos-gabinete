require 'pry'
require 'csv'
require 'json'
require 'open-uri'

recipients = []

Dir.glob('./data/json_data/entries_info/*.json') do |file|

  doc  = open(file).read
  data = JSON.parse(doc)

  data.each do |datum|
    new_recipients = {}
    new_recipients['id'] = datum['id']
    new_recipients['date'] = datum['date']
    new_recipients['value'] = datum['value']
    new_recipients['object'] = datum['object']
    new_recipients['to'] = datum['to']
    new_recipients['cost_center_name'] = datum['cost_center_name']
    new_recipients['provider_name'] = datum['provider_name']
    new_recipients['provider_cpf_cnpj'] = datum['provider_cpf_cnpj']
    new_recipients['provider_type'] = datum['provider_type']
    new_recipients['entry_type_name'] = datum['entry_type_name']

    recipients << new_recipients
  end
end

csv_filepath = './data/csv_data/recipients.csv'
csv_save_options  = { col_sep: ',', force_quotes: true, quote_char: '"' }

CSV.open(csv_filepath, 'wb', csv_save_options) do |csv|
  csv << recipients.first.keys
  recipients.each do |recipient|
    csv << recipient.values
   end
end
