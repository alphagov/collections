class AnswerFinder
  def initialize(term)
    @term = term
  end

  def fetch
    results = search(@term)
    try_find_answer(@term, results)
  end

  def perform_search(term, additional_filters)
    params = {
        start: 0,
        count: 5,
        q: term,
        fields: ['title', 'link']
    }
    params.merge!(additional_filters)
    Services.rummager.search(params)["results"]
  end

  def try_find_department_link(search_term)
    name = find_department_name(search_term)
    if name
      Rails.configuration.department_names.each do |department|
        if department["names"].include?(name)
          return department["href"].split("/").last
        end
      end
    end
  end

  def find_department_name(search_term)
    distances = {}
    search_term.split(" ").each do |search_term_word|
      search_term_word = search_term_word.downcase
      Rails.configuration.all_department_names.each do |department_name|
        distance = lev_distance(department_name.downcase, search_term_word)
        if distance < 0.1
          distances[department_name] = distance
        end
      end
    end
    distances.sort_by{ |key, value| value }
    if distances.any?
      return distances.first.first
    end
  end

  def lev_distance(word_one, word_two)
    distance = Levenshtein.distance(word_one, word_two)
    max_distance = [word_one.length, word_two.length].max.to_f
    map(distance, 0.0, max_distance, 0.0,1.0)
  end

  def map(input, input_min, input_max, output_min, output_max)
    ((input - input_min) / (input_max - input_min) * (output_max - output_min) + output_min)
  end

  def search(term)
    tagger = EngTagger.new
    tagged = tagger.add_tags(term)
    verbs = tagger.get_verbs(tagged)
    filters = {}
    if verbs and verbs.any?
      filters[:filter_content_purpose_supergroup] = "services"
    end
    department = try_find_department_link(term)
    if department
      filters[:filter_organisations] = [department]
    end
    perform_search(term, filters)
  end

  def try_find_answer(term, results)
    return results unless results.count > 1
    score_difference = results.first["es_score"] / results.second["es_score"]
    score_threshold = 2.135 # 2.135 is median of top 500 results difference
    term = clean(term)
    first_result_link = clean(results.first["link"])
    first_result_lev_distance = lev_distance(term, first_result_link)
    if score_difference > score_threshold or first_result_lev_distance < 0.5
      return [results.first]
    end
    []
  end

  def stop_words
    %w(a about above after again against all am an and any are arent as at be
     because been before being below between both but by cant cannot could couldnt
     did didnt do does doesnt doing dont down during each few for from further
     had hadnt has hasnt have havent having he hed hell hes her here heres hers
     herself him himself his how hows i id ill im ive if in into is isnt it
     its its itself lets me more most mustnt my myself no nor not of off on
     once only or other ought our oursourselves out over own same shant she shed
     shell shes should shouldnt so some such than that thats the their theirs them
     themselves then there theres these they theyd theyll theyre theyve this those through
     to too under until up very was wasnt we wed well were weve were werent what
     whats when whens where wheres which while who whos whom why whys with wont would
     wouldnt you youd youll youre youve your yours yourself yourselves)
  end

  def clean(link)
    result = []
    link.split("/").last.gsub("-", " ").downcase.split(" ").each do |word|
      word = word.stem
      if not stop_words.include?(word)
        result << word.stem
      end
    end
    result.join(" ")
  end
end