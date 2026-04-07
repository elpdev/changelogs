json.extract! article,
  :id, :title, :slug, :summary, :content,
  :published_at, :created_at, :updated_at

json.published article.published?
json.reading_time article.reading_time

json.project do
  json.extract! article.project,
    :id, :name, :slug, :language
end
