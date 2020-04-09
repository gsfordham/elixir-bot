defmodule ElixirBot.Command.BotInfo do
	alias Nostrum.Api
	alias Nostrum.Struct.{
		Embed,
		User
	}
	
	alias ElixirBot.Utils
	
	require Logger
	
	def run(message) do
		details = Utils.app_info()
		#IO.puts("#{inspect details}")
		app = details[:app]
		user = details[:bot][:bot_user]
		thumb_link = case user do
			nil -> "https://i.imgur.com/7O3mqHd.png"
			_ -> User.avatar_url(user)
		end
		
		e = %Embed{}
			|> Embed.put_thumbnail(thumb_link)
			|> Embed.put_title("Who Am I")
			|> Embed.put_description("Bot statistics")
			|> fn (e, u, a, msg) -> if u != nil do
					#IO.puts("Bot not nil")
					e
					|> Embed.put_field("General", "ID: #{u.id}\nU/N: #{u.username}")
					|> Embed.put_field("Owner", "#{case a.owner do
						nil -> "Not found"
						_ -> "#{a.owner.username}##{a.owner.discriminator}"
					end}")
					|> fn (e, m, u) -> 
							{:ok, mem} = Api.get_guild_member(m.guild_id, u.id)
							if mem != nil do
								#IO.puts("#{inspect mem}")
								{_, dt, _} = DateTime.from_iso8601(mem.joined_at)
								#IO.puts("DATETIME: #{inspect dt}")
								e
								|> Embed.put_field("Member", "- AKA: '#{
									 if mem.nick == nil do u.username else mem.nick end
								}'\n- Since: #{dt.year}-#{
									String.pad_leading("#{dt.month}", 2, "0")}-#{
									String.pad_leading("#{dt.day}", 2,"0")}\n-- (#{
									String.pad_leading("#{dt.hour}", 2, "0")}:#{
									String.pad_leading("#{dt.minute}", 2, "0")}:#{
									String.pad_leading("#{dt.second}", 2, "0")})")
							end
						end.(msg, u)
				else
					#IO.puts("Bot is nil")
					Embed.put_field(e, "Error", "Could not collect information due to an error")
				end
			end.(user, app, message)
		
		Api.create_message(message.channel_id(), embed: e)
	end
end