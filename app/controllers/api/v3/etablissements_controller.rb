class API::V3::EtablissementsController < ApplicationController
  include Scopable::Controller

  def index
    results = apply_scopes(Etablissement).all
    render json: results, status: 200
  end
end
