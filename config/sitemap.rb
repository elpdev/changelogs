SitemapGenerator::Sitemap.default_host = "https://changelogs.news"

SitemapGenerator::Sitemap.create do
  add projects_path, changefreq: "daily", priority: 0.8

  Project.find_each do |project|
    add project_path(project), lastmod: project.updated_at, changefreq: "weekly", priority: 0.7
  end

  Article.published.find_each do |article|
    add article_path(article), lastmod: article.updated_at, changefreq: "monthly", priority: 0.9
  end
end
