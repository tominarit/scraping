require 'open-uri'
require 'Nokogiri'
require 'mysql2'
require 'csv'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "shrewsbury12", :database => "yahoo_rss")

# スクレイピング先のURL
original_url = 'http://headlines.yahoo.co.jp/rss/list'

#トピックスURLを格納する配列
links = []

charset = nil
html = open(original_url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパースしてオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

#対象トピックスのURLを取得し配列に追加
doc.css('a').each do |element|
  if element[:href].include?("http://news.yahoo.co.jp/pickup/")
    links << element[:href]
  end
end

#ここからXMLの処理

links.each do |link|
  xml = Nokogiri::XML(open(link).read)
  item_nodes = xml.xpath('//channel/item')
  item_nodes.each do |item|
    title = item.xpath('title').text
    link = item.xpath('link').text
    pubDate = item.xpath('pubDate').text
    guid = item.xpath('guid').text
    client.query("insert into Yahoo_RSS (title, link, pubDate, guid) values ('#{title}', '#{link}', '#{pubDate}', '#{guid}')")
  end
end

client.query("select * into outfile '/Users/tominarit/github_test/scraping/result.csv' fields terminated by ',' from Yahoo_RSS")

#puts item.xpath('guid').text
#参考サイト http://www.rokurofire.info/2013/11/11/ruby_db/