class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :provider, inclusion: { in: %w(email facebook twitter vkontakte), message: "%{value} это неприемлимый провайдер" }
end
