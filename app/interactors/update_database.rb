class UpdateDatabase < SireneAsAPIInteractor
  def call
    stdout_info_log 'Checking if last monthly stock link was applied...'
    last_published_stock_name = GetLastMonthlyStockLink.call.link

    unless File.exist?(SaveLastMonthlyStockName.new.full_path)
      stdout_info_log('Last monthly stock link not found.')
      destroy_and_rebuild_database
      return
    end

    if last_monthly_stock_name == last_published_stock_name
      stdout_success_log('Last monthly stock link have already been applied')
      SelectAndApplyPatches.call
    elsif last_monthly_stock_name > last_published_stock_name
      stdout_warn_log('An error occurred : it seems the database is more recent than the last published link.')
    else
      destroy_and_rebuild_database
    end
  end

  private

  def last_monthly_stock_name
    File.read(SaveLastMonthlyStockName.new.full_path)
  end

  def destroy_and_rebuild_database
    stdout_info_log 'New monthly stock available : dropping and rebuilding database from last monthly stock link...'
    DeleteDatabase.call
    PopulateDatabase.call
  end
end
