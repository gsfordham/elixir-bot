defmodule ElixirBot.Utils do
	alias Nostrum.Api
	alias Nostrum.{
		Struct.Embed,
		Struct.User
	}
	
	# Will return either App Info and a Bot User with Nil error
	# or App Info with Nil bot and Error string
	def app_info do
		{:ok, info} = Api.get_application_information()
		bot = get_bot(info[:id])
		%{bot: bot, app: info}
	end
	
	def get_bot(id) do
		{bot, error} = case Api.get_user(id) do
			{:ok, bot} -> {bot, nil}
			_ -> %{user: nil, error: "Failed to access bot user"}
		end
		%{bot_user: bot, error: error}
	end
end