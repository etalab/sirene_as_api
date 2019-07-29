RSpec::Matchers.define 'have_unique_index_on' do |columns|
  match do |table_name|
    ActiveRecord::Base.connection.index_exists?(table_name, columns, unique: true)
  end
end

RSpec::Matchers.define 'have_index_on' do |columns|
  match do |table_name|
    ActiveRecord::Base.connection.index_exists?(table_name, columns)
  end
end
