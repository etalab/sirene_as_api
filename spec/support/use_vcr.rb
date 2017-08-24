def use_vcr
  VCR.use_cassette('sirene_file_index_20170330', allow_playback_repeats: true) do
    yield
  end
end
