require 'open-uri'
require 'Nokogiri'
require 'mysql2'

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

#DBに格納するデータを入れる配列
content = []

links.each do |link|
  xml = Nokogiri::XML(open(link).read)
  item_nodes = xml.xpath('//channel/item')
  item_nodes.each do |item|
    title = item.xpath('title')
    link = item.xpath('link')
    pubDate = item.xpath('pubDate')
    guid = item.xpath('guid')
    client.query("insert into Yahoo_RSS (title) values ('#{title}')")
    client.query("insert into Yahoo_RSS (link) values ('#{link}')")
    client.query("insert into Yahoo_RSS (pubDate) values ('#{pubDate}')")
    client.query("insert into Yahoo_RSS (guid) values ('#{guid}')")
  end
end

#puts item.xpath('guid').text
