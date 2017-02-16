namespace :cache do
  desc "Clear cache"
  task :clear do
    on roles(:app) do |host|
      within current_path do
        info capture(execute :pwd)
        info capture(execute :rake, "cache:clear")
      end
    end
  end
end
