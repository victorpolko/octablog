json.array! @articles do |article|
  json.name article.name
  json.rating article.rating
  json.text article.text
  json.cover_url article.cover.url
  json.author article.author.try(&:full_name)
  json.url article_path(article)
end
