defmodule ElixirBot.Command.UserInfo do
	alias Nostrum.Api
	alias Nostrum.Struct.{
		Embed,
		User
	}
	
	alias ElixirBot.Utils
	
	require Logger
	
	def user(message) do
		mentions = message.mentions
		#IO.puts("#{inspect mentions}")
		l = length(mentions)
		#IO.puts("Length of mentions is: #{l}")
		cond do
			l == 0 -> fn ->
					IO.puts("No user selected -- getting author")
					case Api.get_user(message.author.id) do
						{:ok, user} -> user
						_ -> nil
					end
					|> extract_user(message)
				end.()
			l == 1 -> extract_user((hd mentions), message)
			l > 1 -> fn ->
					Api.create_message(message.channel_id(), "I will only check 1 user per command")
					extract_user((hd mentions), message)
				end.()
			true -> fn ->
					Api.create_message(message.channel_id(), "Something went wrong...")
				end.()
		end
	end
	
	# Extract the user and send the message
	def extract_user(user, message) do
		#IO.puts("User is: #{inspect user}\n\n")
		thumb_link = case user do
			nil -> "https://i.imgur.com/7O3mqHd.png"
			_ -> User.avatar_url(user)
		end
		
		e = %Embed{}
			|> Embed.put_thumbnail(thumb_link)
			|> Embed.put_title("Who dis??")
			|> Embed.put_description("User information")
			|> fn (e, u, msg) -> if u != nil do
					#IO.puts("Bot not nil")
					e
					|> Embed.put_field("General", "ID: #{u.id}\nU/N: #{u.username}##{u.discriminator}")
					|> Embed.put_field("Mention", "<@!#{u.id}>")
					|> fn (e, m, u) -> 
							{:ok, mem} = Api.get_guild_member(m.guild_id, u.id)
							if mem != nil do
								#IO.puts("#{inspect mem}")
								{_, dt, _} = DateTime.from_iso8601(mem.joined_at)
								#IO.puts("DATETIME: #{inspect dt}")
								e
								|> Embed.put_field("Member", "⚗ AKA: '#{
									 if mem.nick == nil do u.username else mem.nick end
								}'\n⚗ Since: #{dt.year}-#{
									String.pad_leading("#{dt.month}", 2, "0")}-#{
									String.pad_leading("#{dt.day}", 2,"0")}\n🧪🧪 (#{
									String.pad_leading("#{dt.hour}", 2, "0")}:#{
									String.pad_leading("#{dt.minute}", 2, "0")}:#{
									String.pad_leading("#{dt.second}", 2, "0")})")
							end
						end.(msg, u)
				else
					#IO.puts("Bot is nil")
					Embed.put_field(e, "Error", "Could not collect information due to an error")
				end
			end.(user, message)
		
		Api.create_message(message.channel_id(), embed: e)
	end
	
	# Get a user's avatar
	def avatar(message) do
		mentions = message.mentions
		#IO.puts("#{inspect mentions}")
		l = length(mentions)
		#IO.puts("Length of mentions is: #{l}")
		cond do
			l == 0 -> fn ->
					#IO.puts("No user selected -- getting author")
					case Api.get_user(message.author.id) do
						{:ok, user} -> user
						_ -> nil
					end
					|> extract_avatar(message)
				end.()
			l == 1 -> extract_avatar((hd mentions), message)
			l > 1 -> fn ->
					Api.create_message(message.channel_id(), "I will only collect 1 avatar per command")
					extract_avatar((hd mentions), message)
				end.()
			true -> fn ->
					Api.create_message(message.channel_id(), "Something went wrong...")
				end.()
		end
	end
	
	# Extract the avatar and send the message
	def extract_avatar(user, message) do
		#IO.puts("User is: #{inspect user}\n\n")
		avatar = case user do
			nil -> "https://i.imgur.com/7O3mqHd.png"
			_ -> User.avatar_url(user)
		end
		
		e = %Embed{}
			|> Embed.put_title("I like your pic!")
			|> Embed.put_description("It is mine, now. 😤")
			|> Embed.put_image(avatar)
		
		Api.create_message(message.channel_id(), embed: e)
	end
end