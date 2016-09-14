require 'sinatra'
require 'mtg_sdk'

get "/" do 
	name = params["name"] || params["text"]
	cards = MTG::Card.where(name: name).all
	if(cards.any?)
		card = cards.find { |c| c.image_url != nil and c.image_url != ""}
		if(!card.nil?)
			return card.image_url	
		else
			return name + " had no matches with images."
		end
	else
		return "No match found."
	end
end