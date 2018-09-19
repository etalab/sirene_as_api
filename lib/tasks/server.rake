namespace :server do
  desc 'Test self server to see if it works'
  task test_self: :environment do
    TestSelfServer.call
  end

  desc 'Switch fallback IP to self'
  task switch: :environment do
    SwitchServer.call
  end
end
