import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import { pipe } from "@dashkite/joy/function"
import { 
  make
  push
  pop
  append
  tag
  save
  clear
  advance
  log 
} from "../src"

do ->

  print await test "dashkite/scan", [

    test "nominal", ->
      scanner = make "start",

        start: [

          [ 
            /^\d+/
            pipe [
              advance
              append
              tag "number"
              save "result"
              clear
            ]            
          ]

          [
            ";"
            pipe [
              advance
              push "comment"
            ]
          ]

          [
            /^\s+/
            advance
          ]

          [
            /^$/
            pop
          ]

        ]

        comment: [
          [
            /.*$/
            pipe [
              advance
              append
              tag "comment"
              save "result"
              clear
              pop
            ]
          ]
        ]
      
      
      { result } = scanner "123 456 ; numbers!"
      assert.deepEqual result, [
        { number: "123" }
        { number: "456" }
        { comment: " numbers!" }
      ]

  ]

  process.exit if success then 0 else 1
