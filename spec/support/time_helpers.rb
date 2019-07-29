def adapt_timestamps(hash)
  ['created_at', 'updated_at'].each do |key|
    hash[key] = hash[key].to_json.gsub("\"", "")
  end
  hash
end

def less_accurate_time
  Time.zone.now.change(usec: 0) { yield }
end
