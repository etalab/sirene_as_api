class Stock
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Nested UniteLegale::Operation::Load
      step Nested Etablissement::Operation::Load
    end
  end
end
