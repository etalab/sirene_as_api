require 'rails_helper'

describe Stock::Task::CreateIndexes do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  # indexes keep existing through RSpec transaction
  # so they need to be deleted
  before do
    Stock::Task::DropIndexes.call table_name: UniteLegale.table_name, logger: logger
    Stock::Task::DropIndexes.call table_name: Etablissement.table_name, logger: logger
  end
  after do
    Stock::Task::DropIndexes.call table_name: UniteLegale.table_name, logger: logger
    Stock::Task::DropIndexes.call table_name: Etablissement.table_name, logger: logger
  end

  it 'creates database indexes on UniteLegale' do
    expect(:unites_legales).not_to have_unique_index_on(:siren)
    subject
    expect(:unites_legales).to have_unique_index_on(:siren)
  end

  it 'creates database indexes on Etablissement' do
    expect(:etablissements).not_to have_index_on(:siren)
    expect(:etablissements).not_to have_index_on(:unite_legale_id)
    expect(:etablissements).not_to have_unique_index_on(:siret)
    subject
    expect(:etablissements).to have_index_on(:siren)
    expect(:etablissements).to have_index_on(:unite_legale_id)
    expect(:etablissements).to have_unique_index_on(:siret)
  end
end
