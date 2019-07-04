require 'net/http'

class UpdateDatabase < SireneAsAPIInteractor
  include Interactor

  def call
    stdout_info_log 'Checking if last monthly stock link was applied...'

    unless File.exist?(SaveLastMonthlyStockName.new.full_path)
      stdout_info_log('Last monthly stock link not found in local save.')
      destroy_and_rebuild_database
      return
    end

    stdout_info_log('Last monthly stock link saved : ' + last_saved_monthly_stock_name)
    update_database_if_needed
  end

  private

  def update_database_if_needed
    if last_saved_monthly_stock_name == last_published_stock_name
      stdout_success_log('Last monthly stock link have already been applied')
      # Deactivationg SelectAndApplyPatches until we get v3 daily updates
      daily_update = SelectAndApplyPatches.call
      PostUpdateTasks.call unless daily_update.links.empty?
    elsif last_saved_monthly_stock_name > context.link
      stdout_error_log('An error occurred : last monthly stock applied is more recent than the last published link.')
    else
      destroy_and_rebuild_database
    end

  end

  def last_published_stock_name
    # Saving the link in context to not call GetLastMonthlyStockLink more than once
    context.link = GetLastMonthlyStockLink.call.link
  end

  def last_saved_monthly_stock_name
    File.read(SaveLastMonthlyStockName.new.full_path)
  end

  def destroy_and_rebuild_database
    stdout_info_log 'Dropping and rebuilding database from last monthly stock link...'
    return unless user_accept_operation
    begin
      DeleteDatabase.call
      PopulateDatabase.call
    rescue StandardError => error
      context.fail!(message: error)
    end
  end

  def user_accept_operation
    return true if context.automatic_update
    stdout_warn_log 'WARNING! This operation will delete and reimport your database
      to make it exactly like the last monthly stock.'
    stdout_warn_log "This will take a few hours. Type 'y' to continue.)"
    user_answer = STDIN.gets.chomp
    return true if user_answer == 'y'
  end
end
