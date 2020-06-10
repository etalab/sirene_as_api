RSpec::Matchers.define 'have_index_on' do |columns|
  match do |table_name|
    options = {}
    options[:unique] = true if @unique
    options[:name] = expected_name if expected_name

    ActiveRecord::Base.connection.index_exists?(table_name, columns, options)
  end

  chain :named, :expected_name

  chain :unique do
    @unique = true
  end
end
