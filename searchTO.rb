class SearchTO
	attr_accessor :name, :set

	def needs_help?
		@name == "help"
	end

	def show_sets?
		@name == "set list"
	end

	def has_set?
		!@set.nil? && @set != ""
	end
end