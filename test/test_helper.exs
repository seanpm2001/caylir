alias Caylir.TestHelpers.Graphs

# start fake server
root = String.to_charlist(__DIR__)

httpd_config = [
  document_root: root,
  modules: [Caylir.TestHelpers.Inets.Handler],
  port: 0,
  server_name: 'caylir_testhelpers_inets_handler',
  server_root: root
]

{:ok, httpd_pid} = :inets.start(:httpd, httpd_config)

inets_env = [
  host: "localhost",
  port: :httpd.info(httpd_pid)[:port]
]

Application.put_env(:caylir, Graphs.InetsGraph, inets_env)

# start graphs
Supervisor.start_link(
  [
    Graphs.DefaultGraph,
    Graphs.InetsGraph,
    Graphs.LimitGraph
  ],
  strategy: :one_for_one
)

# start ExUnit
ExUnit.start()
