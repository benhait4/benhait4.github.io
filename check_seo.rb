require 'nokogiri'
require 'find'

SITE_DIR = File.expand_path('_site', __dir__)

warned = false
Find.find(SITE_DIR) do |path|
  next unless path.end_with?('.html')
  doc = Nokogiri::HTML(File.read(path))
  title = doc.at('title')&.text.to_s.strip
  meta_desc = doc.at('meta[name="description"]')&.[]('content').to_s.strip

  rel_path = path.sub(SITE_DIR + '/', '')

  if meta_desc.empty?
    puts "[SEO WARNING] #{rel_path} is missing a meta description."
    warned = true
  end
  if !title.empty? && title.length > 60
    puts "[SEO WARNING] #{rel_path} has a title exceeding 60 characters (#{title.length})."
    warned = true
  end
end

exit(1) if warned
