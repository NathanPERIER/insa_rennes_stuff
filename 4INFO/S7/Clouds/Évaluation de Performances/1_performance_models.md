
# Performance models


## Operational variables

 - `T` : Duration of the whole experiment
 - `K` : Number of resources in the system
 - `A_i` : Number of **A**rrivals at resource `i`
 - `B_i` : **B**usy time of resource `i`
 - `C_i` : Number of **C**ompletions by resource `i`
 - `A_0` : Total number of requests submitted to the system
 - `C_0` : Total number of requests completed by the system


## Derived variables

 - `S_i = B_i / C_i` : **S**ervice time per completion at resource `i`
 - `λ_i = A_i / T` : Arrival rate at resource `i`
 - `U_i = B_i / T` : **U**tilisation of resource `i`
 - `X_i = C_i / T` : Throughput of resource `i` (i.e. completions per unit time)
 - `X_0 = C_0 / T` : System throughput
 - `V_i = C_i / C_0` : Average number of **v**isits per requests to resource `i`
 - `D_i = V_i * S_i` : Service **D**emand at resource `i`

*Note : the bottleneck of the system is the resource with the highest utilisation*

We reach flow balance when `X = λ`


## Operational laws

 - Utilisation law : `U_i = S_i * X_i`
 - Forced flow law : `X_i = V_i * X_0`
 - Service demand law : `D_i = U_i / X_0`
 - Little's law : `N = X * R`
    + `N` the average number of customers inside a system
	+ `X` the throughput of the system
	+ `R` the response time of the system
 - Interactive response time law : `R = (M / X_0) - Z`
	+ `M` the number of customers
	+ `Z` the think time of the customers


Throughput bounds : `X_0 <= min(1/max({D_i}), N/sum({D_i}))`

Response time bounds : `R => max(N*max({D_i}), sum({D_i}))`

Where `N` is the number of concurrent requests



