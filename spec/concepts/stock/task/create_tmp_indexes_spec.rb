require 'rails_helper'

describe Stock::Task::CreateTmpIndexes do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:table_name) { :etablissements_tmp }
  let(:columns) { :siren }

  # indexes keep existing through RSpec transaction
  # so they need to be deleted manually
  before do
    ActiveRecord::Base.connection.remove_index(table_name, columns) if ActiveRecord::Base.connection.index_exists?(table_name, columns)
  end

  after do
    ActiveRecord::Base.connection.remove_index(table_name, columns)
  end

  it 'creates database indexes on siren' do
    expect(table_name).not_to have_index_on(:siret)
    subject
    expect(table_name).to have_index_on(:siret).unique
  end

  it 'creates many indexes on etablissements' do
    subject
    indexes = ActiveRecord::Base.connection.indexes(table_name)
    expect(indexes).to have(32).items
  end

  it 'limit the size of the longest index name' do
    subject
    expect(table_name)
      .to have_index_on(:activite_principale_registre_metiers)
      .named(:index_etablissements_activite_principale_registre_metiers)
  end
end
