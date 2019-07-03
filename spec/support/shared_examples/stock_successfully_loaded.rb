shared_examples 'stock successfully loaded' do
  it { is_expected.to be_success }

  it 'logs import will start' do
    subject
    expect(logger)
      .to have_received(:info)
      .with("New stock found #{vcr_record_month}, will import...")
  end

  it 'shedule a new ImportStockJob' do
    expect { subject }
      .to have_enqueued_job(ImportStockJob)
      .on_queue('sirene_test_stock')
  end

  it 'persist a new stock to import' do
    expect { subject }.to change(stock_model, :count).by(1)
  end

  its([:remote_stock]) { is_expected.to be_persisted }
  its([:remote_stock]) { is_expected.to have_attributes(uri: expected_uri, status: 'PENDING', month: vcr_record_month, year: '2019') }
end
