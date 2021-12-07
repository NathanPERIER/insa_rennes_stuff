
# Queued Networks

Kendall's notation : `A/B/c/k/N/D`
 - `A` : Arrival process
 - `B` : Service time distribution
 - `c` : Number of servers
 - `k` : System capacity
 - `N` : Population size
 - `D` : Service discipline (FCFS, FCLS, RR, ...)

Possible distributions for `A` and `B` :
 - `M` : Markov
 - `D` : Deterministic
 - `E` : Erlang
 - `H` : Hyper-exponential
 - `G` : General

*Note : Poisson and exponential distributions have the memoryless property*


## Variables

 - `τ` : Interrarival time
 - `λ = 1/E[τ]` : Mean arrival rate
 - `S` : Service time per customer
 - `µ = 1/E[S]` : Mean service rate per server
 - `N_W` : Number of customers waiting in queue
 - `N_S` : Number of customers recieving service
 - `N = N_W + N_S` : Total number of customers in the system
 - `R` or `T` : Response time
 - `W` : Waiting time
 - `ρ` : Server utilisation
 - `ρ_0 = 1 - ρ` : Server idle probability

*Note : the total service rate for `m` servers is `mµ`*


## G/G/1 queue

 - `T = W + E[S]`
 - `N_W = λ*W`
 - `N_S = λ*E[S]`
 - `N = λ*T`
 - `ρ = λ*E[S] = N_S`


## M/M/1 queue

 - `N = ρ/(1-ρ)` so `ρ = N/(1+N)`
 - `T = N/λ = E[S]/(1-ρ)`
 - `W = T - E[S] = ρ*E[S]/(1-ρ)`
 - `N_W = λW = ρ²/(1-ρ)`


## Open Queuing Networks

Arrivals => Poisson processes

We note `Q_i` the Queue lenght of resource `i` and `R_i` its response time

Devices can be modeled as :
 - Load-Independant (LI) resources
    - `Q_i = U_i / (1 - U_i)`
	- `R_i = S_i * (1 + Q_i)`
 - Delay resources
    - `Q_i = U_i`
	- `R_i = S_i`

System response time : `R = sum(R_i * V_i)`


## Mean Value Analysis

Given a closed QN with `N` customers :
 - `R_i(N) = S_i * (1 + Q-i(N-1))` for LI devices
 - `R_i(N) = S_i` for delay devices

Then, it is an iterative process : 
 - `R(N) = sum(V_i * R_i(N))`
 - `X(N) = N / (R(N) + Z)`
 - `Q_i = X_i(N) * R_i(N) = X(N) * V_i * R_i(N)`

