defmodule Ubg5.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      Ubg5Web.Endpoint
      # Starts a worker by calling: Ubg5.Worker.start_link(arg)
      # {Ubg5.Worker, arg},
    ]

    Ubg5.Bibles.init_db()
    
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ubg5.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Ubg5Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
