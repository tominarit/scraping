
require 'open-uri'
require 'Nokogiri'

# スクレイピング先のURL
original_url = 'http://headlines.yahoo.co.jp/rss/list'

#トピックスURLを格納する配列
url = []

charset = nil
html = open(original_url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

#対象トピックスのURLを取得し配列に追加
doc.css('a').each do |element|
  #p element[:href]
  if element[:href].include?("http://news.yahoo.co.jp/pickup/")
    url << element[:href]
  end
end

puts url
