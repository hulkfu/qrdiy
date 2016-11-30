class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lastseenable

  has_one :user_profile
  has_many :projects
  # 参考 Project
  has_many :all_statuses, class_name: :Statue
  has_many :statuses, as: :statusable
end
