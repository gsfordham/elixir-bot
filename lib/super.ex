defmodule ElixirBot.Super do
	use Supervisor
	require Logger
	
	#Start the supervisor
	def start_link(args) do
		Logger.debug(fn -> "Starting supervisor..." end)
		Supervisor.start_link(__MODULE__, args, name: __MODULE__)
	end
	
	@impl true
	def init(_args) do
		children = 
			for n <- 1..System.schedulers_online(),
				do: Supervisor.child_spec({ElixirBot.EventHandler, []},
					id: {:bot, :consumer, n})
		
		Supervisor.init(children, strategy: :one_for_one)
	end
end