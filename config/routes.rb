Rails.application.routes.draw do
  get 'siret/:siret' => 'siret#show'
  get 'siren/:siren' => 'siren#show'
  get 'full_text/:text' => 'full_text#show'
end
