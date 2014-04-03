sweetdiversion
==============

Codepath diversions for specific LÖVE versions using simple expressions

It's safe to use repetitively, as results are cached for specific expressions, making consecutive checks as lightweight as a table lookup.

Example:
```lua
local diversion = require('sweetdiversion')

if diversion('0.9.0') then
  print("You're running 0.9.0")
end

if diversion('>0.8.0') then
  print("You're running something newer than 0.8.0")
end

if diversion('0.9.*') then
  print("You're using some revision of 0.9.x")
end

if diversion('0.9.x') then
  print("You're still running some revision of 0.9.x... " ..
    "You specified the version differently, but it still works!")
end
```
