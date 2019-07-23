require 'rails_helper'

describe API::V3::UnitesLegalesController do
  it_behaves_like 'scopable', :unite_legale, :siren, :nom
end
