-module(main).

-export([run/0]).

run() ->
    {ok, Input} = file:read_file("input.txt"),
    Map = string:split(Input, "\n", all),
    io:format("~p~n", [part_one(Map)]),
    io:format("~p~n", [part_two(Map)]).

part_one(Map) -> slope(Map, [3, 1]).

part_two(Map) ->
    lists:foldl(fun (Angel, Acc) -> Acc * slope(Map, Angel)
                end,
                1,
                [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]).

slope(Map, Angel) -> slope(Map, Angel, 0, 0, 0).

slope(Map, _Angel, _X, Y, Count)
    when Y >= length(Map) ->
    Count;
slope([Head | _] = Map, [Right, Down], X, Y, Count) ->
    Tree = string:slice(lists:nth(Y + 1, Map),
                        X rem string:length(Head),
                        1)
               == <<"#">>,
    slope(Map,
          [Right, Down],
          X + Right,
          Y + Down,
          if Tree -> Count + 1;
             true -> Count
          end).
