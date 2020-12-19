-module(main).

-export([run/0]).

run() ->
    {ok, Input} = file:read_file("input.txt"),
    Lines = lists:map(fun (Line) ->
                              binary:split(Line,
                                           [<<"-">>, <<" ">>, <<": ">>],
                                           [global])
                      end,
                      string:split(Input, "\n", all)),
    io:format("~p~n", [part_one(Lines)]),
    io:format("~p~n", [part_two(Lines)]).

part_one(Lines) ->
    lists:foldl(fun ([Min, Max, Letter, Password], Acc) ->
                        Count = count(binary_to_list(Password),
                                      binary_to_list(Letter)),
                        IsValid = (binary_to_integer(Min) =< Count) and
                                      (Count =< binary_to_integer(Max)),
                        if IsValid -> Acc + 1;
                           true -> Acc
                        end
                end,
                0,
                Lines).

part_two(Lines) ->
    lists:foldl(fun ([One, Two, Letter, Password], Acc) ->
                        OneValue = binary:part(Password,
                                               binary_to_integer(One) - 1,
                                               1),
                        TwoValue = binary:part(Password,
                                               binary_to_integer(Two) - 1,
                                               1),
                        IsValid = (OneValue /= TwoValue) and
                                      ((OneValue == Letter) or
                                           (TwoValue == Letter)),
                        if IsValid -> Acc + 1;
                           true -> Acc
                        end
                end,
                0,
                Lines).

count(Password, Letter) -> count(Password, Letter, 0).

count([Letter | Tail], [Letter], Count) ->
    count(Tail, [Letter], Count + 1);
count([_ | Tail], [Letter], Count) ->
    count(Tail, [Letter], Count);
count([], _, Count) -> Count.
