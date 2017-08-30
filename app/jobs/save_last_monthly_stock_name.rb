class SaveLastMonthlyStockName < SireneAsAPIInteractor
  around do
    context.rebuilding_database = true
    File.open('.last_monthly_stock_name.txt', 'w+') { |f| f << context.link }
  end
end
