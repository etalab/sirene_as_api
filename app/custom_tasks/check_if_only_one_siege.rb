require 'logger'

class CheckIfOnlyOneSiege < SireneAsAPIInteractor
  def call
    create_log_file
    stdout_info_log 'Getting all SIRENs from Database...'
    all_sirens = Etablissement.pluck(:siren)
    @number_errors = 0

    progress_bar = ProgressBar.create(
      total: all_sirens.size,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )

    stdout_info_log 'Checking validity of all SIRENs...'
    all_sirens.each do |siren|
      number_sirets = Etablissement.where(siren: siren).pluck(:siret)
      number_sieges = Etablissement.where(siren: siren, is_siege: "1").count

      stdout_warn_log "BUG : Etablissement #{siren} have #{number_sirets.size}" if number_sirets.size < 1
      validate_single_etablissement(siren, number_sieges) if number_sirets.size == 1
      validate_multiple_etablissements(siren, number_sieges) if number_sirets.size > 1
      progress_bar.increment
    end

    stdout_info_log "Operation finished. #{@number_errors} errors found."
  end

  def create_log_file
    file = File.open('log/check_is_siege.txt', 'w')
    @log = Logger.new(file)
  end

  def validate_single_etablissement(siren, number_sieges)
    if number_sieges != 1
      @number_errors += 1
      stdout_warn_log "ERROR FOUND : Etablissement #{siren} is single for his siren but is_siege = #{number_sieges}"
    end
  end

  def validate_multiple_etablissements(siren, number_sieges)
    if number_sieges != 1
      @number_errors += 1
      stdout_warn_log "ERROR FOUND : Etablissements #{siren} don't have a single siege but #{number_sieges} sieges"
    end
  end

  def stdout_info_log(msg)
    @log.info(msg)
    super
  end

  def stdout_warn_log(msg)
    @log.info(msg)
    super
  end

  def stdout_success_log(msg)
    @log.info(msg)
    super
  end
end
