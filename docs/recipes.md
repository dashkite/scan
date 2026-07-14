# Usage Guides

These recipes demonstrate how to apply the Scan library to solve common parsing challenges.

## Building a Simple Tokenizer

This task involves reading a string of text and extracting contiguous alphabetical characters as words, ignoring spaces.

The software enables this task by allowing you to define distinct modes. The initial mode searches for the start of a word. When a letter appears, the scanner transitions into a word-building mode, accumulating characters until a space forces it back to the initial mode.

```coffeescript
import { make, skip, append, push, pop, save, pipe, clear } from "@dashkite/scan"
import assert from "@dashkite/assert"

# Define the state transitions
rules =
  start:
    " ": skip
    default: pipe [ append, push "word" ]
  word:
    " ": pipe [ save "tokens", clear, pop ]
    default: append

# Compile the parser
parseTokens = make "start", rules

# Parse input text
result = parseTokens "hello world"

# Assert the expected state
assert.deepEqual result.data.tokens, [ "hello", "world" ]
```

### Step-by-Step Explanation

1. **Initialization**: We create a parser starting in the `start` mode.
2. **Whitespace in Start**: If the scanner encounters a space (`" "`) while in the `start` mode, it triggers the `skip` function, leaving the state unaltered.
3. **Word Initiation**: When a non-space character (the `default` case) appears, the pipeline executes. It appends the character to the current token buffer (`state.current`) and pushes the `word` mode onto the stack. The scanner is now in `word` mode.
4. **Building the Word**: While in the `word` mode, any letter (the `default` case) triggers `append`, adding it to the buffer.
5. **Completing the Word**: If a space is encountered while in `word` mode, the pipeline executes. It saves the buffer to `state.data.tokens`, clears the buffer, and pops the `word` mode off the stack, returning the scanner to `start` mode.
