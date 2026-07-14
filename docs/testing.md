# Testing

This document describes the testing approach for the Scan library.

## General Approach

The testing methodology focuses on verifying the correctness of the state machine transitions and string accumulation processes. The test suite, built around `@dashkite/amen` and `@dashkite/assert`, executes the parser against specific input sequences. It asserts that the resulting state objects contain the precise hierarchical token arrays and data structures expected for the defined rules.

## Invoking Tests

To execute the test suite, use the task runner by running the following command from the repository root:

```bash
npx genie test
```
