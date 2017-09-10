#!/usr/bin/ruby -KuU
# encoding: utf-8

# Small library for extracting ngrams from a corpus
# for n = some supplied value

def parse_ngrams(n, string)
  string.split(' ').each_cons(n).to_a
end

def print_ngrams(dir, corpus, n)
  dir = dir.gsub(/([^\/])$/, "\\1/")
  dir_name = File.split(dir)[1]

  ngram_corpus = UnicodeUtils.downcase(corpus)
  ngram_corpus = ngram_corpus.gsub(/# .*/, "").gsub(/#/, "").gsub(/\n/, " ").gsub(/  +/, " ").gsub(/[\.,\?\!"“”•\(\)\[\]\{\}？！，。、（）]/, "")

  ngrams = parse_ngrams(n, ngram_corpus)

  ngram_freq = Hash.new(0)
  ngrams.each do |b|
    ngram_freq[b] += 1
  end
  ngram_output = ""
  ngram_freq.keys.sort.each {|k| ngram_output << ngram_freq[k].to_s + "\t" + k.join(",") + "\n"}
  print_ngrams = ngram_output.split("\n").sort_by{|f| f.split("\t")[0].to_i }.reverse.join("\n")

  File.open("#{n.to_s}grams_#{dir_name}.txt", "w") { |f| f << print_ngrams }

end

def batch_ngram(dir, corpus)
  print_ngrams(dir, corpus, 2)
  print_ngrams(dir, corpus, 3)
  print_ngrams(dir, corpus, 4)
end
