defmodule FinancialTransactionsWeb.Router do
  use FinancialTransactionsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_ensured_authenticated do
    plug :accepts, ["json"]
    plug FinancialTransactionsWeb.AuthAccessPipeline
  end

  pipeline :ensure_user_is_staff do
    plug :accepts, ["json"]
    plug FinancialTransactionsWeb.PermissionsPlug
  end

  scope "/api/v1", FinancialTransactionsWeb do
    pipe_through :api

    resources "/sign_in", SignInController, only: [:create]
  end

  scope "/api/v1", FinancialTransactionsWeb, as: :api_v1 do
    pipe_through [
      :api,
      :api_ensured_authenticated,
      :ensure_user_is_staff,
    ]

    resources "/users", UserController, only: [:index, :create, :show]
    resources "/accounts", AccountController
  end

  scope "/api/v1", FinancialTransactionsWeb, as: :api_v1 do
    pipe_through [
      :api,
      :api_ensured_authenticated,
    ]

    resources "/reports/extract", ExtractReportController, only: [:index]
    resources "/transactions", TransactionController, only: [:create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FinancialTransactionsWeb.Telemetry
    end
  end
end
