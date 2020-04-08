defmodule ElixirBot.EventHandler.Command do
	alias Nostrum.Api
	alias Nostrum.Struct.Embed
	require Logger
	
	@spec handle(map()) :: :ok
	def handle(message) do
		print = &IO.puts/1
		#print.("Message received with the following data:")
		#print.("-Content: #{message.content()}")
		#print.("-Author: #{message.author().username()}")
		fword = hd String.split(message.content(), ~r{\s}, parts: 2)
		#IO.puts(hd fword)
		case fword do
			"#!boop" ->
					IO.puts("Was booped in channel: #{message.channel_id()}")
					e = %Embed{}
					|> Embed.put_title("Booped")
					|> Embed.put_description("The booping occurred in this channel")
					Api.create_message(message.channel_id(), embed: e)
			_ -> nil
		end
		#IO.puts("Message has content: #{message.content()}")
	end
end