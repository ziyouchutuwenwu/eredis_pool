-module(eredis_pool_config).

-behavior(eredis_pool_config_behavior).
-export([get_pool_name/0, get_pool_args/0]).

get_pool_name() ->
	my_redis_conn_pool.

get_pool_args() ->
	PoolArgs = [
		{overrun_warning, 5000},
		{overrun_handler, {?MODULE, my_overrun_handler}},
		{workers, 2},
		{worker, {eredis_worker, [get_worker_args()]}}
	],
	PoolArgs.

%% private
get_worker_args() ->
	WorkerArgs = [
		{ip, "127.0.0.1"},
		{port, 6379}
	],
	WorkerArgs.