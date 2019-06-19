module SlackHelperModule
	def format_response(text, is_private = false)
		response_type = is_private ? "ephemeral" : "in_channel"
		content_type :json
		{ 
			:response_type => response_type,
			:text => text, 
			:attachments => []
		}.to_json
	end

  def delayed_response(text, is_private = false)
		response_type = is_private ? "ephemeral" : "in_channel"
		content_type :json
		{
				:response_type => response_type,
				:text => text,
				:attachments => []
		}.to_json
	end
end