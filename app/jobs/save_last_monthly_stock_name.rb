class SaveLastMonthlyStockName < SireneAsAPIInteractor
  around do
    context.rebuilding_database = true
    unless File.directory?(link_folder)
      FileUtils.mkdir(link_folder)
      stdout_warn_log("Warning : Folder #{link_folder} doesn't exist.
      It will be created for the import to continue.")
    end

    File.open(full_path, 'w+') { |f| f << context.link }
  end

  def link_folder
    '.last_monthly_stock_applied'
  end

  def link_file
    'last_monthly_stock_link_name.txt'
  end

  def full_path
    "#{link_folder}/#{link_file}"
  end
end
