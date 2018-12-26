require 'csv'
require 'moji'

class MecabTweetJob < ApplicationJob
  queue_as :default

  def perform(count = nil)
    mecab = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd')

    csv_data = CSV.read("#{Rails.root}/public/tweet.csv")
    count = csv_data.count if count.nil?

    csv_data.take(count).each do |data|
      next if data[2] =~ /^(@|RT )/

      text = normalize_neologd(data[2])
      tweet = Tweet.new(tweet_id: data[0], tweeted_at: DateTime.strptime(data[1]+' +09:00', '%y%m%d %H%M%S %z'), text: text, length: text.length)

      mecab.enum_parse(text).each do |node|
        break if node.is_eos?

        case node.feature.split(',')[0]
        when '動詞'   then tweet.verb += 1
        when '形容詞' then tweet.adjective += 1
        when '名詞'   then tweet.noun += 1
        when '連体詞' then tweet.pre_noun += 1
        when '副詞'   then tweet.adverb += 1
        when '接続詞' then tweet.conj += 1
        when '記号'   then tweet.symbol += 1
        else               tweet.other += 1
        end

        tweet.word_total += 1
      end

      tweet.save
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
