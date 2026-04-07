SitemapGenerator::Sitemap.default_host = "https://example.com"

SitemapGenerator::Sitemap.create do
  # Add links here, e.g.:
  # add '/about', changefreq: 'monthly', priority: 0.7
  # add '/contact', changefreq: 'yearly'
  #
  # For dynamic content:
  # Post.find_each do |post|
  #   add post_path(post), lastmod: post.updated_at
  # end
end
