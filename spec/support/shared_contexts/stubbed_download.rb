shared_context 'stubbed download' do
  before do
    # mock nested operation to return
    # the fixture file as the downloaded file
    allow_any_instance_of(Files::Operation::Download)
      .to receive(:download_file)
      .and_wrap_original do |method, ctx, **|
      ctx[:file_path] = mocked_downloaded_file
    end
  end
end
