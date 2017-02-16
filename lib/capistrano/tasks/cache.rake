namespace :cache do
  desc "Clear cache"
  task :clear do
    on roles(:cache) do |host|
      within current_path do
        info capture(execute :rake, "cache:clear", "RAILS_ENV=#{fetch(:stage)}")
      end
    end
  end
end
