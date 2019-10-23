unless %w[development test].include?(Rails.env)
  puts 'Renewing INSEE token'
  INSEE::Operation::RenewToken.call
end
