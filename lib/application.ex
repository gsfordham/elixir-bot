defmodule ElixirBot.Bot do
	@moduledoc """
	Documentation for ElixirBot.
	"""

	@doc """
	## Examples
	"""
	require Logger
	use Application
	
	@impl true
	@spec start(
			Application.start_type(),
			term()
		) :: {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, term()}
	def start(_type, _args) do
		#Start the bot
		Logger.debug(fn -> "Starting bot..." end)
		children = [
			ElixirBot.Super
		]
		
		#options = [strategy: :rest_for_one, name: ElixirBot.Super]
		Supervisor.start_link(children, strategy: :rest_for_one)
	end
end