class Stock
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Nested(Server::Operation::AuthorizeImport), fail_fast: true

      pass Nested(LoadUniteLegale)
      pass Nested(LoadEtablissement)
    end
  end
end
