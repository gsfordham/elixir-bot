defmodule ElixirBot.EventHandler do
	alias ElixirBot.EventHandler.{
		#ChannelCreate,
		#ChannelDelete,
		#ChannelUpdate,
		Command,
		##DMUser,
		#GuildBanAdd,
		#GuildBanRemove,
		#GuildCreate,
		#GuildDelete,
		#GuildMemberAdd,
		#GuildMemberRemove,
		#GuildMemberUpdate,
		#GuildRoleCreate,
		#GuildRoleDelete,
		#GuildRoleUpdate,
		MessageCreate,
		#MessageDelete,
		#MessageReactionAdd,
		#MessageUpdate,
		Ready#,
		#UserUpdate
	}
	
	alias ElixirBot.Store
	
	use Nostrum.Consumer
	alias Nostrum.Api, as: Api
	require Logger
	
	@spec start_link :: Supervisor.on_start()
	def start_link do
		Logger.debug(fn -> "Starting event handlers" end)
		Consumer.start_link(__MODULE__)
	end
	
	@impl true
	@spec handle_event(Nostrum.Consumer.event()) :: any()
	def handle_event({:READY, data, _ws_state}) do
		#Logger.debug(fn -> "Logged in and ready to go!!⚗" end)
		Ready.handle(data)
	end
	
	def handle_event({:MESSAGE_CREATE,
		message, _ws_state}) do
		#Logger.debug(fn -> "Got a message" end)
		Command.handle(message)
	end

	# Default event handler, if you don't include this, your consumer WILL crash if
	# you don't have a method definition for each event type.
	def handle_event(_data) do
		#Logger.debug(fn -> "Something happened" end)
	end
end