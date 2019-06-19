require 'rest-client'
require 'json'
require 'mtg_sdk'
require './searchTO.rb'
require './set_map.rb'
require './gag_map.rb'

module MTGHelperModule
	SANITIZATION_CHARACTERS = /(?:\u201C|\u201D|")/
	
	def get_search_term(params)
		name, set = params["text"].split("#")
		if name =~ SANITIZATION_CHARACTERS
			name.gsub!(SANITIZATION_CHARACTERS, "")
			name = "\"#{name}\""
		end
		SearchTO.new.tap do |s|
			s.name = name
			s.set = set.upcase if set && $set_map.keys.include?(set.upcase)
		end
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
		(searchTO.set == "LOL") ? getGagCard(searchTO) : getRealCard(searchTO)
	end

	def getGagCard(searchTO)
		text = "No match found."

		if($gagMap.keys.include?(searchTO.name))
			gag = $gagMap[searchTO.name]
			text = gag[:img] + "\n"
			text += "Story: " + gag[:story]
		end
		text
	end

	def getRealCard(searchTO)
		url = "https://api.scryfall.com/cards/search?q=" + searchTO.name
		response = JSON.parse(RestClient.get(url, headers={}))
		cards = response['data']
		text = ""
		if(cards.any?)
			matches = []
			(1..cards.length - 1).each { |n|
				matches << cards[n]["name"]
			}
			text += "\n" + cards[0]["image_uris"]["normal"] + "\n"
			text += "\nSet: " + cards[0]["set_name"]
			text += "\nPrice: normal(#{cards[0]["prices"]["usd"]}), foil(#{cards[0]["prices"]["usd_foil"]})"
			text += "\nGatherer: " + cards[0]["related_uris"]["gatherer"]
      if(matches.length > 0 )
        text += "\nQuery Matches(#{cards.length.to_i}): #{matches.join(", ")}"
      end
    else
      text = "No match found."
      text += "\n search term: " + searchTO.name
		end
		text
	end
end