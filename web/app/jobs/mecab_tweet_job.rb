require 'csv'
require 'moji'

class MecabTweetJob < ApplicationJob
  queue_as :default

  def perform(*args)
    mecab = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd')
    type_total = Hash.new(0)
    length_total = 0

    csv_data = CSV.read("#{Rails.root}/public/tweet.csv")
    csv_data.take(10).each do |data|
      next if data[2] =~ /^(@|RT )/

      # tweet = Tweet.new(tweet_id: data[0], tweeted_at: DateTime.strptime(data[1]+' +09:00', '%y%m%d %H%M%S %z'), text: data[2])
      # tweet.save

      tweet = normalize_neologd(data[2])
      length_total += tweet.length

      hash = Hash.new(0)
      mecab.enum_parse(tweet).each do |node|
        break if node.is_eos?

        hash[node.feature.split(',')[0]] += 1
        type_total[node.feature.split(',')[0]] += 1
      end
    end
  end

  def normalize_neologd(norm)
    norm.gsub!(/&gt;RT$/, '') # 末尾の>RTを削除
    norm.gsub!(%r{http:\/\/pic.twitter.com\/\w+$}, '') # 添付画像へのリンクを削除
    
    norm.tr!("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")
    norm = Moji.han_to_zen(norm, Moji::HAN_KATA)
    hypon_reg = /(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)/
    norm.gsub!(hypon_reg, "-")
    choon_reg = /(?:﹣|－|ｰ|—|―|─|━)/
    norm.gsub!(choon_reg, "ー")
    chil_reg = /(?:~|∼|∾|〜|〰|～)/
    norm.gsub!(chil_reg, '')
    norm.gsub!(/[ー]+/, "ー")
    norm.tr!(%q{!"#$%&'()*+,-.\/:;<=>?@[¥]^_`{|}~｡､･｢｣"}, %q{！”＃＄％＆’（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」})
    norm.gsub!(/　/, " ")
    norm.gsub!(/ {1,}/, " ")
    norm.gsub!(/^[ ]+(.+?)$/, "\\1")
    norm.gsub!(/^(.+?)[ ]+$/, "\\1")
    while norm =~ %r{([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}
      norm.gsub!( %r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}, "\\1\\2")
    end
    while norm =~ %r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}
      norm.gsub!(%r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}, "\\1\\2")
    end
    while norm =~ %r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}
      norm.gsub!(%r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}, "\\1\\2")
    end
    norm.tr!(
      %q{！”＃＄％＆’（）＊＋，－．／：；＜＞？＠［￥］＾＿｀｛｜｝〜},
      %q{!"#$%&'()*+,-.\/:;<>?@[¥]^_`{|}~}
    )
    norm
  end
end
