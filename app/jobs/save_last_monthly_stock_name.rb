class SaveLastMonthlyStockName < SireneAsAPIInteractor
  around do
    File.open('.last_monthly_stock_name.txt', 'w+') { |f| f << context.link }
  end
end
