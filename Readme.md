I changed the line 37 from `if(dist == "Chisq"){ ` to `if(dist == "Gamma"){`

I also changed line 40 from `rnorm(n, mean = 0, sd= 1)` to `rnorm(n, mean = 50, sd= 2)`

Let me know if these are good changes! I can always go back in and make more changes or different ones if you want!



#### Merge Changes in `Simulation.R` file

I choose the distribution parameters in line 40 to be `rnorm(n, mean = 40 ,5)` and still set the `dist` in line 37 as `Chisq`.

