class API::V2::SirenChildrenGeojsonController < API::V2::SirenChildrenController
  private

  def render_payload_siren_children(result_siege, results_children)
    render json: format_as_json(result_siege, results_children), status: 200
  end

  def format_as_json(result_siege, results_children)
    {
      "type": 'FeatureCollection',
      "total_results": results_children.size + 1,
      "siege_social": json_result(result_siege),
      "features": json_results(results_children)
    }
  end

  def json_result(result)
    {
      "type": 'Feature',
      "geometry": { "type": 'Point', "coordinates": [result[:longitude].to_f, result[:latitude].to_f] },
      "properties": {
        "enseigne": result[:enseigne],
        "siret": result[:siret],
        "address": result[:geo_adresse]
      }
    }
  end

  def json_results(results)
    results.map { |result| json_result(result) }
  end
end
