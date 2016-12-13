module Relationable
  extend ActiveSuppor::Concern

  included do
    has_many :relations, as: :relationable
    
  end
end
