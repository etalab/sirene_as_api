Rails.application.routes.draw do
  get 'siret/:id' => 'siret#show'
  get 'full_text/:id' => 'full_text#show'
end
