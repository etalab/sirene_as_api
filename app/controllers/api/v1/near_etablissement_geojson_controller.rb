require 'sunspot'

class API::V1::NearEtablissementGeojsonController < API::V1::NearEtablissementController
  MAX_ETABLISSEMENTS_RETURNED = 501

  private

  def search_around_etablissement(etablissement, options)
    EtablissementV2.search do |s|
      # Less precise but faster search with bbox
      s.with(:location).in_radius(etablissement[:latitude], etablissement[:longitude], options[:radius], bbox: true)

      s.paginate page: 1, per_page: MAX_ETABLISSEMENTS_RETURNED

      with_faceting(s, options, etablissement)

      # Order by distance from the etablissement, increase return time by ~25%
      s.order_by_geodist(:location, etablissement[:latitude], etablissement[:longitude])
    end
  end

  def render_payload_success(search, results)
    render json: format_as_json(search, results), status: 200
  end

  def format_as_json(search, results)
    {
      "type": 'FeatureCollection',
      "total_results": search.total - 1,
      "features": json_results(results)
    }
  end

  def json_results(results)
    results.pluck(:nom_raison_sociale, :latitude, :longitude)

    results.map do |result|
      {
        "type": 'Feature',
        "geometry": { "type": 'Point', "coordinates": [result[:longitude].to_f, result[:latitude].to_f] },
        "properties": {
          "nom_raison_sociale": result[:nom_raison_sociale],
          "siret": result[:siret],
          "libelle_activite_principale": result[:libelle_activite_principale]
        }
      }
    end
  end
end
