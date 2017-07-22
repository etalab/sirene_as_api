class UpdateDatabase < SireneAsAPIInteractor
  def call
    stdout_info_log 'Checking if last monthly stock link was applied...'
    last_published_stock_name = GetLastMonthlyStockLink.call.link

    unless File.exist?('.last_monthly_stock_name.txt')
      destroy_and_rebuild_database
      return
    end

    if last_monthly_stock_name == last_published_stock_name
      SelectAndApplyPatches.call
    elsif last_monthly_stock_name > last_published_stock_name
      stdout_warn_log('An error occurred : it seems the database is more recent than the last published link.')
    else
      destroy_and_rebuild_database
    end
  end

  private

  def last_monthly_stock_name
    File.read('.last_monthly_stock_name.txt')
  end

  def destroy_and_rebuild_database
    stdout_info_log 'New monthly stock available : dropping and rebuilding database from last monthly stock link...'
    DeleteDatabase.call
    PopulateDatabase.call
  end

  # Code below left for review
  # def last_published_stock_name
  #   silently do
  #     GetLastMonthlyStockLink.call
  #   end
  # end
  #
  # def silently # REVIEW Not sure this works since GetLastMonthlyStockLink inherit from
  #   def stdout_info_log(msg); end
  #   def stdout_warn_log(msg); end
  #   def stdout_success_log(msg); end
  #
  #   yield
  #
  #   def stdout_info_log(msg) # REVIEW Not sure this is necessary either
  #     puts "#{log_prefix}  #{msg.capitalize}"
  #   end
  #
  #   def stdout_warn_log(msg)
  #     puts seven_spaces + msg.capitalize.yellow
  #   end
  #
  #   def stdout_success_log(msg)
  #     puts seven_spaces + "#{check_mark}  #{msg.capitalize}".green
  #   end
  # end
end
