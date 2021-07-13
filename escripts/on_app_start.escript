-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules().

interprete_modules() ->
  int:ni(wpool),
  int:ni(wpool_time_checker),
  int:ni(wpool_shutdown),
  int:ni(wpool_process_sup),
  int:ni(wpool_sup),
  int:ni(eredis),
  int:ni(basho_bench_driver_erldis),
  int:ni(eredis_sub),
  int:ni(eredis_parser),
  int:ni(eredis_client),
  int:ni(basho_bench_driver_eredis),
  int:ni(eredis_sub_client),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").