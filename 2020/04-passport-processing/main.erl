-module(main).

-export([run/0]).

run() ->
    {ok, Input} = file:read_file("input.txt"),
    Passports = scan(string:split(Input, "\n", all),
                     [],
                     #{}),
    io:format("~p~n", [part_one(Passports)]),
    io:format("~p~n", [part_two(Passports)]).

part_one(Passports) ->
    lists:foldl(fun (Passport, Acc) ->
                        Valid = lists:all(fun (Field) ->
                                                  maps:is_key(Field, Passport)
                                          end,
                                          validate_fields()),
                        if Valid -> Acc + 1;
                           true -> Acc
                        end
                end,
                0,
                Passports).

part_two(Passports) ->
    lists:foldl(fun (Passport, Acc) ->
                        Valid = lists:all(fun (Field) ->
                                                  validate(Field,
                                                           maps:get(Field,
                                                                    Passport,
                                                                    nil))
                                          end,
                                          validate_fields()),
                        if Valid -> Acc + 1;
                           true -> Acc
                        end
                end,
                0,
                Passports).

validate_fields() ->
    [<<"byr">>,
     <<"iyr">>,
     <<"eyr">>,
     <<"hgt">>,
     <<"hcl">>,
     <<"ecl">>,
     <<"pid">>].

to_integer(Binary) when is_binary(Binary) ->
    binary_to_integer(Binary);
to_integer(String) -> list_to_integer(String).

validate_number(Value, Min, Max) ->
    Num = to_integer(Value),
    Min =< Num andalso Num =< Max.

validate_re(String, Re) ->
    re:run(String, Re, [{capture, none, list}]) == match.

validate(_, nil) -> false;
validate(<<"byr">>, Value) ->
    validate_number(Value, 1920, 2002);
validate(<<"iyr">>, Value) ->
    validate_number(Value, 2010, 2020);
validate(<<"eyr">>, Value) ->
    validate_number(Value, 2020, 2030);
validate(<<"hgt">>, Value) ->
    case re:run(Value,
                "(\\d+)(cm|in)",
                [{capture, all_but_first, list}])
        of
        {match, [Hgt, "cm"]} -> validate_number(Hgt, 150, 193);
        {match, [Hgt, "in"]} -> validate_number(Hgt, 59, 76);
        _ -> false
    end;
validate(<<"hcl">>, Value) ->
    validate_re(Value, "^#[a-f0-9]{6}$");
validate(<<"ecl">>, Value) ->
    lists:any(fun (V) -> V == Value end,
              [<<"amb">>,
               <<"blu">>,
               <<"brn">>,
               <<"gry">>,
               <<"grn">>,
               <<"hzl">>,
               <<"oth">>]);
validate(<<"pid">>, Value) ->
    validate_re(Value, "^\\d{9}$").

scan([], Passports, Passport) -> [Passport | Passports];
scan([<<>> | Tail], Passports, Passport) ->
    scan(Tail, [Passport | Passports], #{});
scan([Head | Tail], Passports, Passport) ->
    scan(Tail,
         Passports,
         lists:foldl(fun (KV, Acc) ->
                             [K, V] = string:split(KV, ":"),
                             maps:put(K, V, Acc)
                     end,
                     Passport,
                     string:split(Head, " ", all))).
