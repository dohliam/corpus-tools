#!/usr/bin/ruby -KuU
# encoding: utf-8

# == small_wiki_to_text_corpus ==
# This will extract the wiki text from a small mediawiki xml dump,
# such as the database backup dumps found at
# https://dumps.wikimedia.org/backup-index.html
# 
# Note: this will *only* work if the database is small enough
# to be read *entirely* into working memory (RAM)
# 
# The intended use case is for extracting usable / analyzable text
# from minority language wikis.

# Usage:
#   ./small_wiki_to_text_corpus.rb database.xml
# *or*
#   bzcat database.bz2 | ruby small_wiki_to_text_corpus.rb

require 'nokogiri'

xml = ARGV[0]

f = File.read(xml)
doc = Nokogiri::XML(f)

# basic corpus of wikitext:
doc.css('text').each do |link|
  puts link.content
end

doc.css('title').each do |link|
  puts link.content
end
