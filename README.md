# love2d-lotka-volterra [![love2d version](https://img.shields.io/badge/L%C3%96VE-11.3-27a9e0?labelColor=e74999)](https://love2d.org)
Cellural automaton for predator-prey simulation.
Simulation follows very simple rules:
  * there are two types of agents: foxes (red) and rabbits (green)
  * every tick rabbits are born in empty neighbourhood of other rabbits with given probability
  * every rabbit sitting near the fox is eaten, a new fox is born with given probability
  * every fox with no rabbit nearby is hungry and dies with given probability
  * every animal who has empty cell nearby moves into it
  
This simple model yields results simmilar to those obtained by solving Lotka-Volterra equations:
[Wikipedia](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations)

## Running
To run the simulation on linux type `make` in cloned repository.
It will automatically download `love` executable.

![Animals in action](lotka-volterra-animation.gif)

*Written in [Lua](https://www.lua.org/) using awesome [love2d](https://love2d.org/) framework.*
