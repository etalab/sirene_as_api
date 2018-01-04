class SireneAsAPIInteractor
  include Interactor

  def log_prefix
    '------> '
  end

  def stdout_info_log(msg)
    puts "#{log_prefix}  #{msg.capitalize}"
  end

  def stdout_warn_log(msg)
    puts seven_spaces + "#{warning_mark} #{msg.capitalize}".yellow
  end

  def stdout_success_log(msg)
    puts seven_spaces + "#{check_mark}  #{msg.capitalize}".green
  end

  def seven_spaces
    ' ' * 7
  end

  def warning_mark
    "\xE2\x9A\xA0"
  end

  def check_mark
    "\xE2\x9C\x93"
  end

  def time_now
    Time.now
    # Edge case : If you are early january of a year, and you want the last monthly
    # patch of december, replace Time by any time of last year :
    # Time.new(2017, 12, 31)
  end

  def current_year
    time_now.year.to_s
  end

  def current_month
    time_now.month.to_s
  end
end
