Rails.application.routes.draw do
  namespace :v1 do
    get 'siret/:siret' => '/api/v1/siret#show'
    get 'siren/:siren' => '/api/v1/siren#show'
    get 'full_text/:text' => '/api/v1/full_text#show'
    get 'suggest/:suggest_query' => '/api/v1/suggest#show'
  end
end
