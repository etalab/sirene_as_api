require 'rails_helper'

describe DailyUpdate::Operation::NonDiffusables do
  subject { described_class.call logger: Rail.logger }
end
