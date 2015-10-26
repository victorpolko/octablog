class Article < ActiveRecord::Base
  belongs_to :category
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_attached_file :cover, styles: { original: '500>', medium: '300>', thumb: '100x100#' }, default_url: 'assets/default_cover.png'

  validates_attachment :cover, content_type: { content_type: /\Aimage/ }, file_name: { matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i] }, size: { less_than: 10.megabytes }

  validates :name_en, :name_ru, :text, presence: true

  def name
    public_send("name_#{ I18n.locale }")
  end
end

