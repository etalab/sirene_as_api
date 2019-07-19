shared_examples 'having correct log filename' do |filename|
  it 'names the log file according to the model name' do
    expect(Logger).to receive(:new)
      .with(Rails.root.join('log', filename))

    described_class.new.logger_for_import
  end
end

shared_examples 'having related model' do |model|
  it 'has RELATED_MODEL' do
    expect(described_class::RELATED_MODEL).to be model
  end
end
