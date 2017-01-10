namespace :avatar do
  desc "Recrate avatar versions."
  task :recreate_versions => :environment do
    %w(User Project).each do |klass|
      klass.constantize.find_each do |a|
        print '.'
        begin
          if a.avatar?
            a.avatar.recreate_versions!
            # 已经 save，不能再调用 save，否则就会重新生成一个不存在的新文件名
            # 但是老的 versions 不会删除。（如果调用 save 就能删，而且官方也
            # 推荐调用。估计是个 Bug，或是因为我用 hash 生成新的 filename）
          else
            puts "#{klass}: #{a.id} has no avatar."
          end
        rescue => e
          puts  "ERROR: #{klass}: #{a.id} -> #{e.to_s}"
        end
      end
    end
    puts " end."
  end
end
