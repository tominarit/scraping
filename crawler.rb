
require 'open-uri'
require 'Nokogiri'

# スクレイピング先のURL
original_url = 'http://headlines.yahoo.co.jp/rss/list'

url = []

charset = nil
html = open(original_url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

doc.css('a').each do |element|
  #p element[:href]
  if element[:href].include?("pickup")
    url << element[:href]
  end
end

puts url
