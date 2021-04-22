namespace :server do
  desc 'Test self server to see if it works'
  task test_self: :environment do
    TestSelfServer.call
  end

  desc 'Check which server the fallback IP directs to'
  task check_ip: :environment do
    CheckCurrentService.call
  end

  desc 'Switch fallback IP to self'
  task switch: :environment do
    SwitchServer.call
  end
end
