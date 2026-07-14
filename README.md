# Scan

*A state-machine-based scanner library for JavaScript.*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Scan provides a capable and composable toolkit for constructing custom parsers and lexical scanners. By defining a state machine with discrete transition rules, you can process input text character-by-character efficiently. The library includes utility functions to manage state, build strings, and handle transitions gracefully.

## Features

- Constructs parsers using a state machine with mode stacks.
- Employs composable functional rules for managing state, such as pushing and popping modes.
- Provides string-building utilities for accumulating tokens.
- Supports regular expression validation directly within transition rules.
- Memoizes parser output automatically for optimal performance.

## Installation

```bash
pnpm install @dashkite/scan
```

## Usage

Define a starting mode and a set of transition rules. A simple parser might skip whitespace and collect letters into a token.

```coffeescript
import { make, skip, append, push, pop, clear } from "@dashkite/scan"

# rules dictate what happens for each character in the current mode
rules =
  start:
    " ": skip
    default: ( c, state ) ->
      append c, state
      push "word" ( state )
  word:
    " ": ( c, state ) ->
      # processing word ends here
      pop state
      clear state
    default: append

parser = make "start", rules

# invoke the parser on input
result = parser "hello world"
```

## Other Resources

- [Usage Guides](docs/recipes.md)
- [Reference Documentation](docs/reference.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing Approach](docs/testing.md)
