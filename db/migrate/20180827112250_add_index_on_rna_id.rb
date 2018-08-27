class AddIndexOnRNAId < ActiveRecord::Migration[5.0]
  def change
    add_index :etablissements, :numero_rna
  end

  execute "create index on etablissements using gin(to_tsvector('french', numero_rna));"
end
