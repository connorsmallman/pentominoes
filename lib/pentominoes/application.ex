defmodule Pentominoes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PentominoesWeb.Telemetry,
      # Pentominoes.Repo,
      {DNSCluster, query: Application.get_env(:pentominoes, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pentominoes.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pentominoes.Finch},
      # Start a worker by calling: Pentominoes.Worker.start_link(arg)
      # {Pentominoes.Worker, arg},
      # Start to serve requests, typically the last entry
      PentominoesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pentominoes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PentominoesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
