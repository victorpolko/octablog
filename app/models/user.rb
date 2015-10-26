class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]

  has_many :articles, dependent: :destroy
  has_many :authentications, dependent: :destroy

  has_attached_file :avatar, styles: { original: '500x500#', medium: '300x300#', thumb: '100x100#' }, default_url: 'default_avatar.png'

  validates_attachment :avatar, content_type: { content_type: /\Aimage/ }, file_name: { matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i] }, size: { less_than: 10.megabytes }

  validates :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
