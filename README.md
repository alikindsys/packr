# packr

Minecraft modpack manager, written in Haskell this time.

## Why this came to be?

Well, my [old modpack manager](http://github.com/roridev/modmanager.git) had ugly **hardcodes** and i don't like that, *at all*. What better time to remake a "perfectly" functioning project with another?

This should beat it in all ways, by being actually configurable and having an usable cli (instead of whatever TUI garbage the old one had.)  
Also my dumb ass decided it was a good idea to save all of the managed packs in the .minecraft folder, meaning if you reseted .minecraft you'd lose everything. I'm not repeating that design flaw.  


## why?

i lik haskel.

## how to use it

It should end up looking like this.

### `packr new name --version 1.16.1 --loader fabric`
Creates a new modpack

### *new* `packr update`
Updates the current modpack

### `packr list`
Lists all available modpacks


## what i may do in the future

### CurseForge integration

`packr install modA modB modC` (Maybe?)  
`packr upgrade`  
`packr export`  
`packr install myFancyModpack.packr` (This one would be cool af)  

