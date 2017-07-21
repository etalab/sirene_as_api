class SaveLastMonthlyStockName < SireneAsAPIInteractor
  around do |interactor|
    File.open('last_monthly_stock_name.txt', 'w+') { |f| f << context.link }
    puts "DEBUG CONTEXT.LINK: #{context.link}" # DEBUG a virer
  end
end
