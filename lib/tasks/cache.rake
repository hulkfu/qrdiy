namespace :cache do
  desc 'Clear memcache'
  task :clear => :environment do
    Rails.cache.clear
    puts "done."
  end
end
