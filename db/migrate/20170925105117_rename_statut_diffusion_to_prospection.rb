class RenameStatutDiffusionToProspection < ActiveRecord::Migration[5.0]
  def change
    rename_column :etablissements, :statut_diffusion, :statut_prospection
  end
end
