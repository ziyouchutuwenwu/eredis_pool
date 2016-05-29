-module(eredis_pool).

-export([start/1, stop/1]).
-export([my_overrun_handler/1]).

start(BehaviorMod)->
	PoolName = BehaviorMod:get_pool_name(),
	PoolArgs = BehaviorMod:get_pool_args(),
	wpool:start(),
	wpool:start_sup_pool(PoolName, PoolArgs).

stop(BehaviorMod)->
	PoolName = BehaviorMod:get_pool_name(),
	wpool:stop_pool(PoolName),
	wpool:stop().

my_overrun_handler(Report) ->
	io:format("my_overrun_handler ~p~n", [Report]).