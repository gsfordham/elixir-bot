defmodule ElixirBot.Command.Ping do
	alias Nostrum.Api
	alias Nostrum.Struct.Embed
	alias Nostrum.Struct.User
	
	require Logger
	
	def run(message) do
		{:ok, info} = Api.get_application_information()
		{:ok, user} = Api.get_user(info[:id])
		
		tnow = DateTime.utc_now()  #Current time on server
		
		#Message timestamp is in ISO 8601
		mtime = case DateTime.from_iso8601("#{message.timestamp()}") do
			{:ok, t, _} -> t
			_ -> tnow
		end #Time of message
		ping = DateTime.diff(tnow, mtime, :microsecond) #Ping (time difference)
		#IO.puts("Time message sent: #{message.timestamp()}")
		#IO.puts("Time is now: #{Timex.format!(Timex.to_datetime(Timex.now("UTC")))}")
		e = %Embed{}
			#|> Embed.put_author(info[:name], "", User.avatar_url(user))
			|> Embed.put_thumbnail(User.avatar_url(user))
			|> Embed.put_title("Booped")
			|> Embed.put_description("The booping occurred in this channel")
			|> Embed.put_field("Booptime (Ping)", "Total time required to complete a boop:\n#{
					ping}μs (#{Float.round((ping / 1000.0), 2)}ms)")
			|> Embed.put_image("https://i.imgur.com/VBga0wb.gif")
			Api.create_message(message.channel_id(), embed: e)
	end
end