namespace :avatar do
  desc "Recrate avatar versions."
  task :recreate_versions => :environment do
    %w(User Project).each do |klass|
      klass.constantize.find_each do |a|
        print '.'
        if a.avatar?
          a.avatar.recreate_versions!
          a.save!
        else
          puts "#{klass}: #{a.id} has no avatar."
        end
      end
    end
    puts " end."
  end
end
