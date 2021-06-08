defmodule DoIt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DoIt.Repo,
      # Start the Telemetry supervisor
      DoItWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DoIt.PubSub},
      # Start the Endpoint (http/https)
      DoItWeb.Endpoint
      # Start a worker by calling: DoIt.Worker.start_link(arg)
      # {DoIt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoIt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DoItWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
