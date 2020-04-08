defmodule ElixirBot.Storager do
	#alias ElixirBot.GuildStore, as: GS
	
	def new do
		Agent.start(fn -> [servers: []] end, name: :unit)
	end
	
	def add_guild(guild) do
		#Agent.update(:unit, fn [servers: sv] ->
		#	[servers: sv ++ %GS{id: guild.id()}]
		#end)
	end
end