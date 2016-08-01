require 'feedjira'
require 'date'
require 'nokogiri'
require 'json'

feed = Feedjira::Feed.parse File.open('./icodeit.atom.20160801.xml').read

feeds_data = {}
feed.entries.each_with_index do |entity, index|
	feeds_data["feed-#{index}"] = {
		:url => entity.url,
		:title => entity.title,
		:author => entity.author || 'unknown',
		:summary => Nokogiri::HTML.parse(entity.content || "").text[0..100]+'...',
		:publishDate => entity.updated.to_date.to_s
	}
end

result = {}
result["feeds"] = feeds_data
print result.to_json