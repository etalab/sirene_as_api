require 'rails_helper'

describe Stock::Task::DropIndexes do
  subject { described_class.call table_name: table_name, logger: logger }

  let(:logger) { instance_spy Logger }

  before do
    Stock::Task::CreateIndexes.call logger: logger
  end
  after do
    Stock::Task::DropIndexes.call table_name: UniteLegale.table_name, logger: logger
    Stock::Task::DropIndexes.call table_name: Etablissement.table_name, logger: logger
  end

  context 'unites_legales table' do
    let(:table_name) { UniteLegale.table_name }

    it 'drops database indexes on UniteLegale' do
      expect(:unites_legales).to have_unique_index_on(:siren)
      subject
      expect(:unites_legales).not_to have_unique_index_on(:siren)
    end

    it 'does not drop indexes on etablissements' do
      subject
      expect(:etablissements).to have_unique_index_on(:siret)
      expect(:etablissements).to have_index_on(:siren)
      expect(:etablissements).to have_index_on(:unite_legale_id)
    end
  end

  context 'etablissements table' do
    let(:table_name) { Etablissement.table_name }

    it 'drop database indexes on Etablissement' do
      expect(:etablissements).to have_index_on(:siren)
      expect(:etablissements).to have_index_on(:unite_legale_id)
      expect(:etablissements).to have_unique_index_on(:siret)
      subject
      expect(:etablissements).not_to have_index_on(:siren)
      expect(:etablissements).not_to have_index_on(:unite_legale_id)
      expect(:etablissements).not_to have_unique_index_on(:siret)
    end

    it 'does not drop indexes on unites_legales' do
      subject
      expect(:unites_legales).to have_unique_index_on(:siren)
    end
  end
end
