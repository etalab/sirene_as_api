require 'rails_helper'

describe Stock::Task::DropTmpIndexes do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:table_name) { :unites_legales_tmp }
  let(:columns) { :siren }

  # indexes keep existing through RSpec transaction
  # so they need to be deleted manually
  before do
    ActiveRecord::Base.connection.add_index(table_name, columns)
  end

  it 'drops database indexes on UniteLegale' do
    expect(table_name).to have_index_on(:siren)
    subject
    expect(table_name).not_to have_index_on(:siren)
  end
end
