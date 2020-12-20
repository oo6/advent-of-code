-module(main).

-export([run/0]).

run() ->
    {ok, Input} = file:read_file("input.txt"),
    Seats = lists:map(fun (Route) ->
                              boarding(Route, [0, 127], 0)
                      end,
                      string:split(Input, "\n", all)),
    io:format("~p~n", [part_one(Seats)]),
    io:format("~p~n", [part_two(Seats)]).

part_one(Seats) -> lists:max(Seats).

part_two(Seats) -> find_seat(lists:sort(Seats)).

boarding(<<"F", Tail/binary>>, [Lower, Upper], Seat) ->
    if Lower + 1 == Upper ->
           boarding(Tail, [0, 7], Lower * 8);
       true ->
           boarding(Tail,
                    [Lower, math:floor((Lower + Upper) / 2)],
                    Seat)
    end;
boarding(<<"B", Tail/binary>>, [Lower, Upper], Seat) ->
    if Lower + 1 == Upper ->
           boarding(Tail, [0, 7], Upper * 8);
       true ->
           boarding(Tail,
                    [math:ceil((Lower + Upper) / 2), Upper],
                    Seat)
    end;
boarding(<<"L", Tail/binary>>, [Lower, Upper], Seat) ->
    if Lower + 1 == Upper -> round(Seat + Lower);
       true ->
           boarding(Tail,
                    [Lower, math:floor((Lower + Upper) / 2)],
                    Seat)
    end;
boarding(<<"R", Tail/binary>>, [Lower, Upper], Seat) ->
    if Lower + 1 == Upper -> round(Seat + Upper);
       true ->
           boarding(Tail,
                    [math:ceil((Lower + Upper) / 2), Upper],
                    Seat)
    end.

find_seat([Left, Right | _]) when Left + 2 == Right ->
    Left + 1;
find_seat([_ | Tail]) -> find_seat(Tail).
