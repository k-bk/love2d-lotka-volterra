# love2d-lotek-volterra
Cellural automaton for predator-prey simulation.
Simulation follows very simple rules:
  * there are two types of agents: foxes (red) and rabbits (green)
  * every tick rabbits are born in empty neighbourhood of other rabbits with given probability
  * every rabbit sitting near the fox is eaten, a new fox is born with given probability
  * every fox with no rabbit nearby is hungry and dies with given probability
  * every animal who has empty cell nearby moves into it
  
This simple model yields results simmilar to those obtained by solving Lotka-Volterra equations:
[Wikipedia](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations)

![Animals in action](https://github.com/karolBak/love2d-lotek-volterra/blob/master/screen.png)
