require 'rails_helper'

describe Stock::Helper::DatabaseIndexes do
  subject { dummy_class.new }

  let(:dummy_class) { Class.new { include Stock::Helper::DatabaseIndexes } }

  it 'yields table_names, indexes and options' do
    expect do |b|
      subject.each_index_configuration(&b)
    end.to yield_control.exactly(59).times
  end
end
