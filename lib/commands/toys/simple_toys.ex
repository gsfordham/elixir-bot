defmodule ElixirBot.Command.SimpleToys do
	alias Nostrum.Api
	alias Nostrum.Struct.{
		Embed,
		User
	}
	
	alias ElixirBot.Utils
	
	require Logger
	
	def respect(message) do
		words = (tl String.split(message.content(), ~r{\s}, parts: 2))
		#IO.puts("Words: #{words}")
		
		e = %Embed{}
		|> Embed.put_thumbnail("https://i.imgur.com/Cxsf8OZ.png")
		|> Embed.put_image("https://i.imgur.com/gHPvgJH.jpg")
		|> Embed.put_title("F")
		|> Embed.put_description("<@!#{message.author.id}> has paid their respects")
		|> fn (e, w) ->
				if length(w) > 0 do
					Embed.put_field(e, "⚰In memory of📿", "#{w}")
				else
					e
				end
			end.(words)
		
		Api.create_message(message.channel_id(), embed: e)
	end
end