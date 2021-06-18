# A file to store secret environment variables for test environment
use Mix.Config

user_password =
  System.get_env("USERPASSWORD") ||
    raise """
    environment variable USERPASSWORD is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :do_it, :basic_auth, username: "hello", password: user_password
