module Relationable
  extend ActiveSupport::Concern

  included do
    has_many :relations, as: :relationable

    Relation::NAMES.keys.each do |name|
      define_method "#{name}" do
        puts "RRR #{name}"
      end
    end
  end



end
