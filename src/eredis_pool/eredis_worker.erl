-module(eredis_worker).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(conn_record, {conn}).

start_link([Args]) ->
  gen_server:start_link(?MODULE, [Args], []).

init([Args]) ->
  Ip = proplists:get_value(ip, Args),
  Port = proplists:get_value(port, Args),

  {ok, Conn} = eredis:start_link(Ip, Port),
  ConnRecord = #conn_record{conn = Conn},

  io:format("working thread init ~p,~p~n", [self(), ConnRecord]),
  process_flag(trap_exit, true),
  {ok, ConnRecord}.

%redis的一些查询命令封装
handle_call({single_query, Cmd}, _From, #conn_record{conn = Conn} = State) ->
  Result = eredis:q(Conn, Cmd),
  {reply, Result, State};

handle_call({pipeline_query, CmdList}, _From, #conn_record{conn = Conn} = State) ->
  Result = eredis:qp(Conn, CmdList),
  {reply, Result, State};

handle_call({transcation_query, CmdList}, _From, #conn_record{conn = Conn} = State) ->
  {ok, <<"OK">>} = eredis:q(Conn, ["MULTI"]),
  lists:foreach(
    fun(Cmd) ->
      {ok, <<"QUEUED">>} = eredis:q(Conn, Cmd)
    end,
    CmdList),
  Result = eredis:q(Conn, ["EXEC"]),
  {reply, Result, State};

handle_call(_Request, _From, State) ->
  {reply, _Reply = ok, State}.


handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({'EXIT', _Pid, Reason}, State) ->
  io:format("exit reason ~p~n", [Reason]),
  case Reason of
    normal ->
      io:format("normal exit trapped~n"),
      {stop, normal, State};
    other ->
      io:format("other exit trapped~n"),
      {noreply, State}
  end;
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, #conn_record{conn = Conn} = State) ->
  eredis:stop(Conn),
  io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.