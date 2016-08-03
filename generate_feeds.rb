require 'feedjira'
require 'date'
require 'nokogiri'
require 'json'
require 'securerandom'

# feed = Feedjira::Feed.parse File.open('./icodeit.atom.20160801.xml').read
feed = Feedjira::Feed.parse File.open('./jianshu-editor-notes.xml').read

feeds_data = {}
feed.entries.each do |entity|
	node = Nokogiri::HTML.parse(entity.content || entity.summary|| "")
	imgs = node.css('img')

	post_url = ''
	if imgs.size > 0 then
		post_url = imgs[0].attr('src')
	end

	feeds_data[SecureRandom.uuid.gsub('-', '')] = {
		:url => entity.url,
		:title => entity.title,
		:author => entity.author || 'unknown',
		:summary => node.text[0..100]+'...',
		:publishDate => (entity.updated || DateTime.now).to_date.to_s,
		:heroImage => post_url
	}
end

result = {}
result["feeds"] = feeds_data
print result.to_json
