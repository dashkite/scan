import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import * as p from "../src"

do ->

  print await test "dashkite/scan", []

  process.exit if success then 0 else 1
