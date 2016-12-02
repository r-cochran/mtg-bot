require 'mtg_sdk'
require './searchTO.rb'
require './set_map.rb'

module MTGHelperModule
	
	def get_search_term(params)
		terms = params["text"].split("#")
		name = terms[0]
		set = terms[1]
		if(name.include?("\“") || name.include?("\“"))
			name = name.gsub("\“", "")
			name = name.gsub("\“", "")
			name = name.gsub("\"", "")
			name = "\"" + name + "\""
		end
		searchTO = SearchTO.new()
		searchTO.name = name
		if(!set.nil? && ($set_map.keys.include?(set) || $set_map.keys.include?(set.upcase)))
			searchTO.set = set.downcase;
		end	
		searchTO
	end

	def get_help()
		"Partial card search on any text.\n" +
		"Exact card search with name wrapped in \"\".\n\tExample: \"Ezuri, Claw of Progress\".\n" + 
		"Set/Edition search with #<set_shorthand>.\n\tExample: Diabolic Tutor#kld.\n" +
		"\tuse /mtg-bot set list for full list."
	end

	def get_set_list()
		sets = "Sets: "
		$set_map.each do |key, value|
			sets += "\t" + value + ": " + key + "\n"
		end
		sets
	end

	def getCard(searchTO)
		cards = MTG::Card.where(name: searchTO.name, set: searchTO.set).all
		text = "No match found."
		
		if(cards.any?)
			card = cards.find { |c| c.image_url != nil and c.image_url != ""}
			if(!card.nil?)
				text = card.image_url	
			else
				text = name + " had no matches with images."
			end
		end
		text += "\n search term: " + searchTO.name
		if(searchTO.has_set?)
			text += "\n set: " + searchTO.set + " - " + $set_map[searchTO.set]
		end
		text
	end
end