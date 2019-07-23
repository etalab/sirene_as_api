shared_context 'mute interactors' do
  let(:original_stderr) { $stderr }
  let(:original_stdout) { $stdout }

  before do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
