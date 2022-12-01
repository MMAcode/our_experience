defmodule OurExperience.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OurExperienceWeb.Telemetry,
      # Start the Ecto repository
      OurExperience.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: OurExperience.PubSub},
      # Start Finch
      {Finch, name: OurExperience.Finch},
      # Start the Endpoint (http/https)
      OurExperienceWeb.Endpoint
      # Start a worker by calling: OurExperience.Worker.start_link(arg)
      # {OurExperience.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OurExperience.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OurExperienceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
