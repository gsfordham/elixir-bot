defmodule ElixirBot.EventHandler.Ready do
	alias Nostrum.Api
	alias ElixirBot.GuildStore, as: GS
	alias ElixirBot.Store
	require Logger
	
	@spec handle(map()) :: :ok
	def handle(data) do
		print = &IO.puts/1
		
		print.("Logged in and ready to go!⚗")
		:ok = Api.update_status(:online, "Hello World!", 1)
		{:ok, bot_info} = Api.get_application_information()
		{:ok, guilds} = Api.get_current_user_guilds()
		print.("---------")
		print.("-Signed in as: #{bot_info[:name]} (#{bot_info[:id]})")
		print.("-Programmer info: #{bot_info[:owner][:username]} (#{bot_info[:owner][:id]})")
		print.("-Hosted in: #{length(guilds)} guilds")
		#Enum.each(guilds, fn(g) -> 
		#	print.("--Guild: '#{g.name()}'")
		#	chans = case Api.get_guild_channels(g.id()) do
		#		{:ok, chans} -> chans
		#		_ -> []
		#	end
		#	print.("---Other info: #{length(chans)}")
		#end)
		print.("-Total channels in all guilds: #{
				Enum.reduce(guilds, 0, fn(g, acc) -> 
					length(chans = case Api.get_guild_channels(g.id()) do
						{:ok, chans} -> chans
						_ -> []
					end) + acc end)
			}")
		print.("---------\n")
	end
end