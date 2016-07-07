json.array!(@items) do |item|
  json.extract! item, :id, :title, :content
  json.url item_url(item, format: :json)
end
