-module(eredis_pool_query_test).

-compile(export_all).

start_pool()->
  eredis_pool:start(eredis_pool_config).

stop_pool()->
  eredis_pool:stop(eredis_pool_config).

single_query() ->
  Cmd = ["SET", "foo", "bar"],
  eredis_pool_query:single_query(eredis_pool_config, Cmd).

pipeline_query() ->
  Cmds = [
    ["SET", "foo", "bar"],
    ["SET", "bar", "baz"]
  ],
  eredis_pool_query:pipeline_query(eredis_pool_config, Cmds).

transcation_query() ->
  Cmds = [
    ["SET", a, "1"],
    ["LPUSH", b, "3"],
    ["LPUSH", b, "2"]
  ],
  eredis_pool_query:transcation_query(eredis_pool_config, Cmds).