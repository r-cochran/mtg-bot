require 'sinatra'
require 'mtg_sdk'
require 'json'

get "/mtg-bot" do 
	name = params["name"] || params["text"]
	cards = MTG::Card.where(name: name).all
	text = "No match found."
	
	if(cards.any?)
		card = cards.find { |c| c.image_url != nil and c.image_url != ""}
		if(!card.nil?)
			text = card.image_url	
		else
			text = name + " had no matches with images."
		end
	end

	content_type :json
	{ 
		:response_type => "in_channel",
		:text => text, 
		:attachments => []
	}.to_json
end