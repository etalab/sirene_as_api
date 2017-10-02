class SaveLastMonthlyStockName < SireneAsAPIInteractor
  around do
    context.rebuilding_database = true
    unless File.directory?(link_folder)
      FileUtils.mkdir(link_folder)
      stdout_warn_log("Warning : Folder #{link_folder} doesn't exist.
      It will be created for the import to continue, but it is supposed to be a shared folder created by Mina deploy.")
    end

    File.open("#{link_folder}/#{link_file}", 'w+') { |f| f << context.link }
  end

  def link_folder
    '.last_monthly_link_applied'
  end

  def link_file
    'last_monthly_stock_name.txt'
  end
end
