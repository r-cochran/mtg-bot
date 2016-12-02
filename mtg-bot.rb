require 'sinatra'
require 'json'
require './searchTO.rb'
require './mtg-helper.rb'
require './slack-helper.rb'

helpers MTGHelperModule
helpers SlackHelperModule

get "/mtg-bot" do 
	searchTO = get_search_term(params)
	
	if(searchTO.needs_help?)
		format_response(get_help(), true)	
	elsif(searchTO.show_sets?)
		format_response(get_set_list(), true)
	else
		format_response(getCard(searchTO))
	end
end