shared_context 'stubbed download' do
  before do
    # copy fixture file into tmp dir
    file = Pathname.new(downloaded_fixture_file)
    dest = Rails.root.join('tmp', 'files', file.basename).to_s
    FileUtils.copy(downloaded_fixture_file, dest)

    # mock nested operation to return
    # the fixture file as the downloaded file
    allow_any_instance_of(Files::Operation::Download)
      .to receive(:download_file)
      .and_wrap_original do |_method, ctx, **|
      ctx[:file_path] = dest
    end
  end
end
