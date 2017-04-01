class SireneAsAPIInteractor
  include Interactor

  def log_prefix
    '------> '
  end

  def check_mark
    "\xE2\x9C\x93"
  end

  def stdout_warn_log(msg)
    puts msg.capitalize.yellow
  end

  def stdout_success_log(msg)
    puts "#{check_mark}  #{msg.capitalize}".green
  end

  def stdout_info_log(msg)
    puts "#{log_prefix}  #{msg.capitalize}"
  end
end
