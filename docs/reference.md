# Reference Documentation

This document describes the public interface for the Scan library.

## pipe

$pipe: functions \to function$

Composes an array of functions into a single pipeline. Each function processes the state returned by the previous function.

```coffeescript
import { pipe, trim, lower } from "@dashkite/scan"
normalize = pipe [ trim, lower ]
```

## skip

$skip: input, state \to state$

Ignores the input character and returns the state without modifications.

## push

$push: mode \to function$

Returns a state transition function that pushes the specified mode onto the mode stack.

## pop

$pop: state \to state$

Pops the current mode off the mode stack, returning to the previous mode.

## poke

$poke: mode \to function$

Returns a state transition function that replaces the top mode on the stack with the specified mode.

## trim

$trim: state \to state$

Trims whitespace from the current buffered token string in `state.current`.

## lower

$lower: state \to state$

Converts the current buffered token string in `state.current` to lowercase.

## tag

$tag: name \to function$

Returns a function that replaces `state.current` with an object, wrapping the original token value in the provided name key.

## save

$save: name \to function$

Returns a function that appends the string in `state.current` to the array located at `state.data[name]`.

## clear

$clear: state \to state$

Resets the buffer in `state.current` to an empty string.

## append

$append: character, state \to state$

Appends the current character to the buffer in `state.current`. If invoked with only the character, it returns a curried function that waits for the state.

## prefix

$prefix: text, function \to function$

Returns a state transition function that prepends the specified text to the character before passing it to the inner function.

## buffer

$buffer: character, state \to state$

Assigns the current character to `state.buffer`, allowing it to be processed later.

## unbuffer

$unbuffer: function \to function$

Returns a state transition function that retrieves the character from `state.buffer`, clears the buffer, and executes the inner function with the buffered character.

## match

$match: pattern \to function$

Returns a state transition function that validates `state.current` against a regular expression pattern. If the pattern test fails, it throws an error.

## log

$log: label \to function$

Returns a state transition function that logs the character or state to the console, primarily used for debugging.

## make

$make: start\_mode, rules \to function$

Compiles the state transition rules into a memoized parser function. The parser begins executing from the specified starting mode.
