require 'rails_helper'

describe Stock::Task::RenameIndexes do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:table_name) { :unites_legales }
  let(:columns) { :siren }
  let(:index_name) { :dummy_name }

  # indexes keep existing through RSpec transaction
  # so they need to be deleted manually
  before do
    ActiveRecord::Base.connection.add_index(table_name, columns, name: index_name)
  end

  after do
    ActiveRecord::Base.connection.remove_index(table_name, column: columns)
  end

  it 'rename database indexes on UniteLegale and add suffix _tmp' do
    expect(table_name).to have_index_on(:siren).named(index_name)
    subject
    expect(table_name).to have_index_on(:siren).named("#{index_name}_tmp")
  end
end
