#!/usr/bin/ruby -KuU
# encoding: utf-8

require "unicode_utils/downcase"
require_relative 'ngrams.rb'

def dir_to_corpus(dir, corpus_container)
  dir = dir.gsub(/([^\/])$/, "\\1/")

  files = Dir.glob(dir + "*")

  files.each do |filename|
    if File.basename(filename) == "README.md" then next end
    file_content = File.read(filename)
    story_content = file_content.gsub(/##\n\* License: .*/m, "")
    corpus_container << story_content + "\n"
  end
end

corpus = ""

# read input from a file, directory, or pipe
if ARGV[0]
  args = ARGV[0]
  if File.directory?(args)
    dir = File.absolute_path(args)
    dir_to_corpus(dir, corpus)
    batch_ngram(dir, corpus)
  else
    file_content = File.read(args)
    batch_ngram(Dir.pwd, file_content)
  end
elsif ARGF
  file_content = ARGF.read
  batch_ngram(Dir.pwd, file_content)
else
  abort("  Please specify a source file or directory.")
end
