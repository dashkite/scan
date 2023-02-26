import { memoize } from "@dashkite/lru-cache"

pipe = ( fx ) ->
  switch fx.length
    when 1 then -> fx[0].apply null, arguments
    when 2 then -> fx[1] fx[0].apply null, arguments
    when 3 then -> fx[2] fx[1] fx[0].apply null, arguments
    when 4 then -> fx[3] fx[2] fx[1] fx[0].apply null, arguments
    when 5 then -> fx[4] fx[3] fx[2] fx[1] fx[0].apply null, arguments
    when 6 then -> fx[5] fx[4] fx[3] fx[2] fx[1] fx[0].apply null, arguments
    when 7 then -> fx[6] fx[5] fx[4] fx[3] fx[2] fx[1] fx[0].apply null, arguments
    else ( args... ) ->
      for f in fx
        args = [ f.apply null, args ]       
      args[0]

export { pipe }

skip = ( input, state ) -> state

export { skip }

push = ( mode ) ->
  ( state ) ->
    state.mode.push mode
    state

export { push }

pop = ( state ) ->
  state.mode.pop()
  state

export { pop }

poke = ( mode ) ->
  ( state ) ->
    state.mode.pop()
    state.mode.push mode
    state

export { poke }

trim = ( state ) ->
  state.current = state.current.trim()
  state

export { trim }

save = ( name ) ->
  (state ) ->
    ( state.data[ name ] ?= [] ).push state.current
    state
export { save }

clear = ( state ) ->
  state.current = ""
  state

export { clear }

append = ( c, state ) ->
  # faux currying so we don't need to define
  # a second function for the case where we 
  # fix the text being appended
  if state?
    state.current += c
    state
  else
    ( state ) ->
      state.current += text
      state

export { append }

# appendText = ( text ) ->

# export { appendText }

prefix = ( text, f ) ->
  ( c, state ) -> f "#{text}#{c}", state

export { prefix  }

getContext = ( state ) ->
  i = state.index
  state.text[( i - 5)..( i + 5 )]

getMode = ( state ) ->
  state.mode[ state.mode.length - 1 ]

getExpected = ( state ) ->
  mode = getMode state
  ( Object.keys state.rules[ mode ] ).join ", "

isFinished = ( start, state ) ->
  state.mode.length == 1 && state.mode[0] == start  

run = ( input, state ) ->
  mode = getMode state
  if ( group = state.rules[ mode ] )?
    if ( rule = ( group[ input ] ? group.default ) )?
      rule input, state
    else
      expected = getExpected state
      context = getContext state
      throw new Error "parse error at '#{ context }'.
        Expected one of: [ #{ expected } ], got: '#{ input }'"
  else
    throw new Error "parser in an unknown state: #{ mode }"

make = ( rules, start ) ->
  memoize ( text ) ->
    state =
      mode: [ start ]
      data: {}
      current: ""
      text: text
      rules: rules
    try
      for c, i in text
        state.index = i
        run c, state
      if isFinished start, state
        run "end", state
      else
        mode = getMode state
        throw new Error "unexpected end of input while parsing [ #{ mode } ]"
    catch error
      context = getContext state
      console.error "unexpected parse error at '#{ context }' on: [ #{ input } ]."
      throw error

export { make }