import { isKind } from "@dashkite/joy/type"
import { memoize } from "@dashkite/lru-cache"

advance = ( state ) -> 
  state.remains = state.remains[ state.buffer.length.. ]
  state

export { advance }

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

lower = ( state ) ->
  state.current = state.current.toLowerCase()
  state

export { lower }

tag = ( name ) ->
  ( state ) ->
    state.current = [ name ]: state.current
    state

export { tag }

save = ( name ) ->
  ( state ) ->
    ( state.data[ name ] ?= [] ).push state.current
    state

export { save }

map = ( transform ) ->
  ( state ) ->
    state.current = transform state.current
    state

export { map }

clear = ( state ) ->
  state.current = ""
  state

export { clear }

append = ( state ) ->
  state.current += state.buffer
  delete state.buffer
  state

export { append }

prefix = ( text ) ->
  ( state ) -> 
    state.buffer = "#{ text }#{ state.buffer }"

suffix = ( text ) ->
  ( state ) -> 
    state.buffer += text

export { prefix  }

copy = ( name ) ->
  ( state ) ->
    state.buffers[ name ] = state.buffer
    state

paste = ( name ) ->
  ( state ) ->
    state.buffer = state.buffers[ name ]
    state

export { copy, paste }

match = ( re ) ->
  ( state ) ->
    if re.test state.current
      state
    else
      throw new Error "match failed"

export { match }

log = ( label ) ->
  ( state ) ->
    console.log [ label ]: state
    state

export { log }

getContext = ( state ) ->
  state.remains[..5]

getMode = ( state ) ->
  state.mode[ state.mode.length - 1 ]

getExpected = ( state ) ->
  state
    .rules[( getMode state )]
    .map ([ pattern ]) -> pattern
    .join ", "

isFinished = ( state ) ->
  state.mode.length == 0

match = ( pattern, text ) ->
  if isKind String, pattern
    pattern if text.startsWith pattern
  else if isKind RegExp, pattern
    m[ 0 ] if ( m = text.match pattern )?
    
run = ( state ) ->
  mode = getMode state
  if ( group = state.rules[ mode ] )?
    for [ pattern, rule ] in group
      if ( buffer = match pattern, state.remains )?
        state = rule { state..., buffer }
        break
    if !buffer?
      expected = getExpected state
      context = getContext state
      throw new Error "parse error at '#{ context }...'.
        Expected one of: [ #{ expected } ]"
    state
  else
    throw new Error "parser in an unknown state: #{ mode }"

make = ( start, rules ) ->
  memoize ( text ) ->
    state =
      mode: [ start ]
      text: text
      remains: text
      current: ""
      buffers: {}
      data: {}
      rules: rules
    done = ->
      ( state.remains.length == 0 ) &&
        ( state.mode.length == 0 )
    try
      ( state = run state ) until done()
      if isFinished state
        state.data
      else
        throw new Error "unexpected end of input
          while parsing [ #{ getMode state } ]"
    catch error
      # TODO add line no and char
      context = getContext state
      console.error "unexpected parse error at
        '#{ context }...' in: [ #{ getMode state } ]."
      throw error

export { make }