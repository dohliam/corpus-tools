# corpus-tools - A collection of scripts for working with multilingual text corpora

This repository contains a collection of small ruby scripts for working with text corpora. While there are many sophisticated corpus analysis tools already available, the purpose of these scripts was to provide a lightweight, "quick and dirty" analysis of unconventional and not necessarily optimized collections of text in different languages.

The tools originally developed from the challenges encountered while building [stoplists for a large number of African languages](https://github.com/dohliam/more-stoplists), but they have also been used for a variety of other purposes, including providing data and resources for [language revitalization](https://github.com/dohliam/hawaiian-corpus).

## Requirements

* ruby
* The `unicode_utils` gem (to convert non-Latin text to lowercase, since `downcase` in the core library cannot handle this)

## Scripts

The following scripts can be found in the `scripts/` folder.

### corpus_freq.rb

This script will print a frequency list to standard output for all texts in a given folder, all words in a file, or all text in a pipe. It has been tailored for use with the texts from the [ASP corpus](https://github.com/global-asp/asp-source).

#### Usage

    ruby corpus_freq.rb [path/to/directory]

_or_

    ruby corpus_freq.rb filename.txt

_or_

    ruby cat sometext.txt | corpus_freq.rb


### ngrams.rb

A small library for extracting ngrams from a corpus (for _n_ = some supplied value). This is required for using the `print_ngrams.rb` script.

### print_ngrams.rb

A script for parsing n-grams (sequences of adjacent words) in a corpus. As with the other scripts, it can take input from a file, directory, or pipe. It will automatically create a series of files containing lists of n-grams for three pre-determined values of _n_ (specifically, bigrams, trigrams, and 4-grams), although the ngrams library allows for _n_ to be any arbitrary number.

To output n-grams for different values of _n_, just edit the script to comment out the two lines with `batch_ngram(dir, corpus)` and replace them with the following:

    print_ngrams(dir, corpus, n)

(Where `n` is any number.)

### salient.rb

Given a stoplist for a particular language and a text file written in that language, print a frequency list of the most "salient" or "interesting" high frequency words (i.e., words that are not common [stop words](https://en.wikipedia.org/wiki/Stop_words)).

#### Usage

Process a frequency list directly:

    ./salient.rb frequency_list.txt

Process any raw text file using a pipe:

    ./corpus_freq.rb filename.txt | ruby salient.rb

#### Stoplist configuration

In order to use the `salient.rb` script, you need to first configure the location of your list of stop words, and the language of the source file.

This can be done by either configuring these values directly at the top of the script file, or by specifying them using command-line options (see [the section below](#options) for details).

If your source files are usually in one particular language, it is probably easier to configure the script itself and use the command-line options for one-offs. The variables to configure in the script are as follows:

* `stoplist_dir`: A directory containing stoplists in json format needs to be specified here. A good example with a wide selection of languages can be found in the "dist" folder of the [stopwords-json](https://github.com/6/stopwords-json) project.
* `lang`: The [ISO code](https://en.wikipedia.org/wiki/ISO_639-1) for the language of the source text (this has to be a language that is available in your stoplist directory). Example: `de` (German) or `fr` (French)

#### Options

Command-line options override the values configured in the script, so they are a convenient way to specify temporary values (e.g. for a language you don't usually work with, or an experimental list of stopwords).

The following options are available:

* `-l` (`--language CODE`): _Language code to use for processing_
* `-s` (`--stoplist-dir DIR`): _Directory containing stoplist files_

So for example, to find salient words in a Portuguese source file (`filename.txt`), you could use the following command:

    ./corpus_freq.rb filename.txt | ruby salient.rb -l pt
    
To specify the location of your stoplist directory, just add it using `-s` option:

    ./corpus_freq.rb filename.txt | ruby salient.rb -l pt -s /path/to/stoplist_dir

### stats.rb

Print corpus statistics for a specified corpus. Just point this script at your corpus file or directory and it will churn out a wide variety of statistics including the total number of files, words, and lines in the corpus, as well as the average number of words per file, and the top five most and least frequent words.

See the [statistics from the Swahili corpus](https://github.com/dohliam/more-stoplists/blob/master/sw/corpus_stats-sw.md) for an example of what the generated statistics look like.

### small_wiki_to_text_corpus.rb

This will extract the wiki text from a small mediawiki xml dump, such as the database backup dumps found [here](https://dumps.wikimedia.org/backup-index.html).

Note: this will *only* work if the database is small enough to be read *entirely* into working memory (RAM).

The intended use case is for extracting usable / analyzable text from minority language wikis. The resulting text can be piped to `stats.rb`, `corpus_freq.rb`, or other scripts in this repo.

#### Usage

If you have an extracted xml file:

    ./small_wiki_to_text_corpus.rb database.xml

Or work directly with the bzip-compressed dump:

    bzcat database.bz2 | ruby small_wiki_to_text_corpus.rb


## License

MIT.
