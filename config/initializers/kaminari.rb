##
# RailsAdmin 用的 Kaminari，和 will_paginate 冲突了
# https://github.com/sferik/rails_admin/wiki/Troubleshoot#conflict-between-will_paginate-and-kaminari
#
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
