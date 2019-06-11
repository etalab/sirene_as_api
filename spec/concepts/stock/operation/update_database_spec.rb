require 'rails_helper'

describe Stock::Operation::UpdateDatabase do
  subject { described_class.call logger: logger }

  let(:logger) { instance_double(Logger).as_null_object }


end
