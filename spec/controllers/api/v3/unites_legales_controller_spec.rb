require 'rails_helper'

describe API::V3::UnitesLegalesController do
  include_context 'api v3 response',       :unite_legale, :siren, :nom

  it_behaves_like 'a scopable controller', :unite_legale, :siren, :nom
  it_behaves_like 'a REST API',            :unite_legale, :siren, :nom
end
