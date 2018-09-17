class TaxonSearchesController < ApplicationController
  def create
    taxon_search = TaxonSearch.new(params[:q])
    taxon_search.fetch
    @results = taxon_search.results
    answer_finder = AnswerFinder.new(params[:q])
    @answer = answer_finder.fetch
    taxon_search.print
    render "create.js.erb"
  end
end



# Useful for analysis
#
# file = File.open("mostcommonresults.csv").read
# results = ""
# file.split("\n").each do |row|
#   row_parts = row.split(",")
#   search_term = row_parts.first
#   results += search(search_term)
# end
# File.open("results_with_departments.csv", 'w') { |file| file.write(results) }


# First attempt using TF-IDF. Kept as a record

# class Matcher
#   def initialize(q)
#     @q = q
#   end
#
#   def score
#     stemmed_query = fetch_stemmed_search
#     results = fetch_results
#     word_frequencies = fetch_word_frequencies(stemmed_query, results)
#     idf = calculate_idf(results.count, word_frequencies)
#     result_scores = fetch_result_scores(stemmed_query, results, idf)
#     p "RANKED SCORES"
#     result_scores.sort_by{ |title, score| score }.each do |result_score|
#       p "#{result_score.first.join(" ")},#{result_score.second}"
#     end
#     result_scores.sort_by{ |title, score| score }.first
#   end
#
#   def fetch_result_scores(stemmed_query, results, idf)
#     scores = {}
#     results.each do |result|
#       scores[result[:stemmed_title]] = fetch_score(stemmed_query, result, idf)
#     end
#     scores
#   end
#
#   def fetch_score(stemmed_query, result, idf)
#     tf_idfs = []
#     stemmed_query.each do |query_word|
#       if result[:stemmed_title].count > 0 && result[:stemmed_title].count(query_word) > 0
#         tf = (result[:stemmed_title].count(query_word).to_f / result[:stemmed_title].count.to_f)
#         tf_idfs << (idf[query_word] * tf)
#       end
#     end
#     return Float::INFINITY unless tf_idfs.any?
#     p "#{result[:stemmed_title].join(" ")}: #{tf_idfs.join(", ")}"
#     # tf_idfs.median
#   end
#
#   def calculate_idf(number_documents, word_frequencies)
#     idf = {}
#     word_frequencies.each_pair do |word, frequency|
#       idf[word] = Math.log10(number_documents.to_f / frequency.to_f)
#     end
#     idf
#   end
#
#   def fetch_word_frequencies(stemmed_query, results)
#     word_frequencies = Hash.new(0)
#     results.each do |result|
#       result[:stemmed_title] = split_sentence(result["title"])
#       stemmed_query.each do |query_word|
#         if result[:stemmed_title].include?(query_word)
#           word_frequencies[query_word] += 1
#         end
#       end
#     end
#     word_frequencies
#   end
#
#   def fetch_stemmed_search
#     stemmed_search = []
#     split_sentence(@q).each do |word|
#       if not stop_words.include?(word)
#         stemmed_search << word.stem
#       end
#     end
#     stemmed_search
#   end
#
#   def fetch_results
#     params = {
#         start: 0,
#         count: 20,
#         q: @q,
#         fields: ['title', 'link']
#     }
#     Services.rummager.search(params)["results"]
#   end
#
#
#
#   def split_sentence(sentence)
#     sentence.downcase.gsub("'", "").split(" ")
#   end
#
# end
#
# module Enumerable
#
#   def median
#     sorted = self.sort
#     len = self.count
#     (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
#   end
#
# end