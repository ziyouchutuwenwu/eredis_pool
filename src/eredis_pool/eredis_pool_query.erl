-module(eredis_pool_query).

%% API
-export([single_query/2, pipeline_query/2, transcation_query/2]).

single_query(BehaviorMod, Cmd) ->
	PoolName = BehaviorMod:get_pool_name(),
	wpool:call(PoolName, {single_query, Cmd}, best_worker).

pipeline_query(BehaviorMod, CmdList) ->
	PoolName = BehaviorMod:get_pool_name(),
	wpool:call(PoolName, {pipeline_query, CmdList}, best_worker).

transcation_query(BehaviorMod, CmdList) ->
	PoolName = BehaviorMod:get_pool_name(),
	wpool:call(PoolName, {transcation_query, CmdList}, best_worker).