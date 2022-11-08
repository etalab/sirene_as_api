require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  if Rails.env.production?
    Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_AUTH_USERNAME'])
      ) &
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_AUTH_PASSWORD'])
      )
    end

    mount Sidekiq::Web, at: '/sidekiq'
  elsif Rails.env.development?
    mount Sidekiq::Web, at: '/sidekiq'
  end



  concern :v1_routes do
    get 'siret/:siret' => '/api/v1/siret#show'
    get 'siren/:siren' => '/api/v1/siren#show'
    get 'full_text/:text' => '/api/v1/full_text#show'
    get 'suggest/:suggest_query' => '/api/v1/suggest#show'
    get 'near_etablissement/:siret' => '/api/v1/near_etablissement#show'
    get 'near_etablissement_geojson/:siret' => '/api/v1/near_etablissement_geojson#show'
    get 'near_point/' => '/api/v1/near_point#show'
    get 'rna/:rna' => '/api/v1/numero_rna#show'
  end

  concern :v2_routes do
    get 'siren/:siren' => '/api/v2/siren#show'
    get 'siren/:siren/etablissements' => '/api/v2/siren_children#show'
    get 'siren/:siren/etablissements_geojson' => '/api/v2/siren_children_geojson#show'
  end

  concern :v3_routes do
    get 'unites_legales/' => '/api/v3/unites_legales#index'
    get 'unites_legales/:siren' => '/api/v3/unites_legales#show'

    get 'etablissements/' => '/api/v3/etablissements#index'
    get 'etablissements/:siret' => '/api/v3/etablissements#show'
  end

  namespace :v1 do
    concerns :v1_routes
  end

  namespace :v2 do
    concerns :v2_routes
  end

  namespace :v3 do
    concerns :v3_routes
  end

  # DIRTY FIX (nginx configuration and url prefixing do not work)
  scope '/api/sirene/' do
    namespace :v1 do
      concerns :v1_routes
    end

    namespace :v2 do
      concerns :v2_routes
    end

    namespace :v3 do
      concerns :v3_routes
    end
  end
end
