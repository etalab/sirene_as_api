class EtablissementRowJobs
  def fill_etablissements
    etablissements = []

    lines.each do |line|
      etablissements << EtablissementAttrsFromLine.instance.call(line)
    end
    etablissements
  end
end
