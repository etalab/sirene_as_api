class InsertEtablissementRowsJob < EtablissementRowJobs
  attr_accessor :lines

  def initialize(lines)
    @lines = lines
  end

  def perform
    etablissements = fill_etablissements

    ar_keys = %w[created_at updated_at]
    ar_keys << etablissements.first.keys.map(&:to_s)
    ar_keys.flatten

    ar_values_string = etablissements.map { |h| value_string_from_enterprise_hash(h) }.join(', ')

    ar_query_string = "INSERT INTO etablissements_v2 (#{ar_keys.join(',')})
                      VALUES
                      #{ar_values_string};"
    insert(ar_query_string)
    true
  end

  def insert(ar_query_string)
    ActiveRecord::Base.connection.execute(ar_query_string)
  rescue StandardError => e
    stdout_error_log "Error: Cannot insert etablissement attributes. Cause : #{e.class}
      Make sure that your Solr server is launched for the right environment and accessible."
    exit
  end

  def value_string_from_enterprise_hash(hash)
    # Used for updated_at and created_at that etablissement model requires
    now_string = Time.now.utc.to_s

    between_parenthesis = hash.values.map do |v|
      if v.nil?
        'NULL'
      else
        "'#{v.gsub("'", "''")}'"
      end
    end.join(',')

    "('#{now_string}', '#{now_string}', #{between_parenthesis})"
  end
end
