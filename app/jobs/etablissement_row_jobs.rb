class EtablissementRowJobs < SireneAsAPIInteractor
  def fill_etablissements
    etablissements = []
    begin
      lines.each do |line|
        etablissements << EtablissementAttrsFromLine.instance.call(line)
      end
    rescue StandardError => e
      stdout_error_log "Error: Could not finish the import task. Cause: #{e.class}"
      exit
    end

    etablissements
  end
end
