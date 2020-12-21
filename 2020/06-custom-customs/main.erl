-module(main).

-export([run/0]).

run() ->
    {ok, Input} = file:read_file("input.txt"),
    Lines = string:split(Input, "\n", all),
    io:format("~p~n", [part_one(Lines)]),
    io:format("~p~n", [part_two(Lines)]).

part_one(Lines) ->
    lists:foldl(fun (Stat, Acc) -> Acc + maps:size(Stat)
                end,
                0,
                answers_stat_by_person(union, Lines, [#{}])).

part_two(Lines) ->
    lists:foldl(fun (Stat, Acc) -> Acc + maps:size(Stat) - 1
                end,
                0,
                answers_stat_by_person(intersection, Lines, [#{}])).

answers_stat_by_person(_Type, [], Stats) -> Stats;
answers_stat_by_person(Type, [<<>> | Lines], Stats) ->
    answers_stat_by_person(Type, Lines, [#{} | Stats]);
answers_stat_by_person(union, [Line | Lines],
                       [Stat | Stats]) ->
    answers_stat_by_person(union,
                           Lines,
                           [answers_stat_by_ques(Line, Stat) | Stats]);
answers_stat_by_person(intersection, [Line | Lines],
                       [Stat | Stats]) ->
    IsEmpty = maps:size(Stat) == 0,
    NewStat = if IsEmpty ->
                     answers_stat_by_ques(Line, #{started => true});
                 true ->
                     maps:with([started
                                | maps:keys(answers_stat_by_ques(Line, #{}))],
                               Stat)
              end,
    answers_stat_by_person(intersection,
                           Lines,
                           [NewStat | Stats]).

answers_stat_by_ques(<<>>, Stat) -> Stat;
answers_stat_by_ques(<<Q:1/binary, Questions/binary>>,
                     Stat) ->
    answers_stat_by_ques(Questions,
                         maps:put(Q, true, Stat)).
