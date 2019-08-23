shared_context 'mute progress bar' do
  before do
    dbl_bar = instance_double(ProgressBar::Base, increment: nil)
    allow(ProgressBar).to receive(:create).and_return dbl_bar
  end
end
