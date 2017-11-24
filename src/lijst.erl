-module(lijst).

-export([start/0, stop/0]).

-export([init/0, loop/1, get/0, add/1]).

start() ->
    Pid = spawn(?MODULE, init, []),
    register(lijst, Pid),
    {ok, Pid}.

stop() ->
    lijst ! {stop}.

init() ->
    loop([]),
    {ok, []}.

get() ->
    lijst ! {get, self()},
    receive
       Result -> Result
    end.

add(Element) ->
    lijst ! {add, Element}.

loop(Lijst) ->
   receive
      {get, From} ->
         From ! Lijst,
         loop(Lijst);
      {add, Element} ->
         loop(lists:sort([Element|Lijst]));
      {stop} ->
         ok;
      _ ->
         loop(Lijst)
   end.
