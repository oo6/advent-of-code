Definitions.
FORWARD = forward
UP = up
DOWN = down
DIGITS = [0-9]+
WHITESPACE = [\s\t\r\n]+

Rules.
{WHITESPACE} : skip_token.
{FORWARD} : {token, {move, forward}}.
{UP} : {token, {move, up}}.
{DOWN} : {token, {move, down}}.
{DIGITS} : {token, {number, list_to_integer(TokenChars)}}.

Erlang code.
