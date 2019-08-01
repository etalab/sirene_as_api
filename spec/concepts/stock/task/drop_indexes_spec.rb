require 'rails_helper'

describe Stock::Task::DropIndexes do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  before do
    Stock::Task::CreateIndexes.call logger: logger
  end

  it 'drops database indexes on UniteLegale' do
    expect(:unites_legales).to have_unique_index_on(:siren)
    subject
    expect(:unites_legales).not_to have_unique_index_on(:siren)
  end

  it 'drop database indexes on Etablissement' do
    expect(:etablissements).to have_index_on(:siren)
    expect(:etablissements).to have_unique_index_on(:siret)
    subject
    expect(:etablissements).not_to have_index_on(:siren)
    expect(:etablissements).not_to have_unique_index_on(:siret)
  end
end
