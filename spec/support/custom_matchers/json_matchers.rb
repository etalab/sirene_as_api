# Helpers to check specs for pure JSON Api
RSpec::Matchers.define :look_like_json do
  match do |string|
    JSON.parse(string)
  rescue JSON::ParserError
    false
  end

  failure_message do |string|
    "\"#{string}\" is not parsable by JSON.parse"
  end

  description do
    'Expect to be JSON parsable string'
  end
end

def body_as_json
  json_str_to_hash(response.body)
end

def json_str_to_hash(str)
  JSON.parse(str).with_indifferent_access
end
