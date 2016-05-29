-module(eredis_pool_config_behavior).

-callback get_pool_name() ->
	PoolName::atom().

-callback get_pool_args() ->
	PoolArgs::list().