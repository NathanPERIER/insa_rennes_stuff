---
tags: AWN, Assignment
author: Nathan PERIER
title: Advanced Wireless Networks - Home Assignment 3
---

# Home Assignment 3 - WAN

## Question 1 (10 points)

> The system has 4 cells, in each cell there are 182 users. Each user generates load of 25 mErlangs.
> 
> What is the blocking probability in one cell when there are 8 channels available in the cell ?

The ingress traffic in one cell is $A = 182 \times 0.025 = 4.55 \,E$ and we have $m = 8$ channels available. Hence, according to the Erlang B formula :

$$
P_b = \frac{\frac{A^m}{m!}}{\sum^m_{i=0} \frac{A^i}{i!}} = \boxed{0.05}
$$

> What is the blocking probability when cells are combined and served by one big cell 4x8 channels ?

This time, the ingress traffic is $A = 4 \times 182 \times 0.025 = 18.2 \,E$ and we have $m = 4 \times 8 = 32$ channels available. Hence, according to the Erlang B formula :

$$
P_b = \frac{\frac{A^m}{m!}}{\sum^m_{i=0} \frac{A^i}{i!}} = \boxed{10^{-3}}
$$

> What is the calling rate in one cell ? The average call duration is 100s.

The total load is $A = 182 \times 0.025 = 4.55 \,E$.

We know that $A = \lambda \cdot E[X]$, where $X$ is the random variable of the call duration and $\lambda$ is the arrival rate. In order to stick with the definition of an erlang, we will consider the durations expressed in hours. It follows that :

$$
\lambda = \frac{A}{E[X]} = \frac{4.55 \times 3600}{100} = \boxed{163.8 \,call/h}
 = 4.55 \times 10^{-2} \,call/s$$

## Question 2 (40 points)

Calculate the performance of an OFDM grid in 5G networks. Consider the following configuration of a cell (gNB) in a 5G network : 

- FDD
- $SCS$ Sub-carrier Spacing
- $DL\_BW$ MHz DL bandwidth
- $UL\_BW$ MHz UL bandwidth
- $DL\_MCS\_table$ in DL
- $UL\_MCS\_table$ in UL
- Slot-based scheduling is in use
- $DL\_overhead\_OS$ OFDM symbols overhead per slot in DL  
- $UL\_overhead\_OS$ OFDM symbol overhead per slot in UL
- Up to $DL\_max\_rank$ MIMO layers in DL
- Up to $UL\_max\_rank$ MIMO layers in UL

Use the following set of parameters :

| Parameter          | Value                  |
|:-------------------|:-----------------------|
| $SCS$              | 15 kHz                 |
| $DL\_BW$           | 10 MHz                 |
| $UL\_BW$           | 10 MHz                 |
| $DL\_MCS\_table$   | 64 QAM table (table 1) |
| $UL\_MCS\_table$   | 64 QAM table (table 1) |
| $DL\_overhead\_OS$ | 2 OFDM symbol(s)       |
| $UL\_overhead\_OS$ | 1 OFDM symbol(s)       |
| $DL\_max\_rank$    | 4 layers               |
| $UL\_max\_rank$    | 2 layers               |

### Task 1 

> Calculate cell _maximum_ possible throughput in DL and in UL, assuming _highest_ MCS and _highest_ MIMO scheme. Write your answer in Mbps.

We have $SCS = 15kHz$, hence the slot duration is $T_{slot} = 1ms$ according to the tables.

Since we use 64 QAM as a modulation scheme, the modulation order is $Q_m = 6$. According to the tables, we then get that the max MCS index is $I_{MCS,max} = 19$, for which the spectral efficiency is $S_{eff} = 5.5547$.

The number of OFDM symbols per resource block is $N_{OS} = 14$.

Since the bandwidth is $DL\_BW = UL\_BW = 10 MHz$ and the sub-carrier spacing is $SCS = 15 kHz$, we get from the 64 QAM table (table 1) that the number of resource blocks in a sub-carrier is $N_{RB} = 52$ for both cases.

#### Download

At highest MIMO scheme, we have $N_{layers} = DL\_max\_rank = 4$.

We get that the maximum download throughput is :

$$
\begin{aligned}
R_{DL,max} & = \frac{N_{RB} \cdot N_{subcarriers} \cdot (N_{OS} - DL\_overhead\_OS) \cdot N_{layers} \cdot S_{eff}}{T_{slot}} \\
& = \frac{52 \times 12 \times (14 - 2) \times 4 \times 5.5547}{0.001} \\
& = \boxed{166.4 \,Mbps}
\end{aligned}
$$

#### Upload

At highest MIMO scheme, we have $N_{layers} = UL\_max\_rank = 2$.

We get that the maximum upload throughput is :

$$
\begin{aligned}
R_{UL,max} & = \frac{N_{RB} \cdot N_{subcarriers} \cdot (N_{OS} - UL\_overhead\_OS) \cdot N_{layers} \cdot S_{eff}}{T_{slot}} \\
& = \frac{52 \times 12 \times (14 - 1) \times 2 \times 5.5547}{0.001} \\
& = \boxed{90.1 \,Mbps}
\end{aligned}
$$

### Task 2

> Calculate _maximum_ possible throughput in DL and in UL _per user_ in a cell, assuming 10 users, _highest_ MCS and _highest_ MIMO scheme. Write your answer in Mbps.

Here we only have to divide the results from the previous task by the number of users $N_{users} = 10$.

#### Download

$$
R_{DL,max,user} = \frac{R_{DL,max}}{N_{users}} = \frac{166.4}{10} = \boxed{16.64 \,Mbps}
$$

#### Upload

$$
R_{UL,max,user} = \frac{R_{UL,max}}{N_{users}} = \frac{90.1}{10} = \boxed{9.01 \,Mbps}
$$

### Task 3

> Calculate cell _minimum_ possible throughput in DL and in UL _per user_, assuming 3 users, _lowest_ MCS and _lowest_ MIMO scheme. Write your answer in Mbps.

For the same reasons as in task 1, we get that :

- $T_{slot} = 1ms$
- $N_{OS} = 14$
- $N_{RB} = 52$

Since we use 64 QAM as a modulation scheme, the modulation order is $Q_m = 6$. According to the tables, we then get that the min MCS index is $I_{MCS,min} = 17$, for which the spectral efficiency is $S_{eff} = 2.5664$.

Since we use the lowest MIMO scheme, we have $N_{layers} = 1$.

We suppose that the traffic is evenly distributed between the $N_{users} = 3$ users.

#### Download

$$
\begin{aligned}
R_{DL,max,user} & = \frac{N_{RB} \cdot N_{subcarriers} \cdot (N_{OS} - DL\_overhead\_OS) \cdot N_{layers} \cdot S_{eff}}{T_{slot} \cdot N_{users}} \\
& = \frac{52 \times 12 \times (14 - 2) \times 1 \times 2.5664}{0.001 \times 3} \\
& = \boxed{6.41 \,Mbps}
\end{aligned}
$$

#### Upload

$$
\begin{aligned}
R_{UL,max,user} & = \frac{N_{RB} \cdot N_{subcarriers} \cdot (N_{OS} - UL\_overhead\_OS) \cdot N_{layers} \cdot S_{eff}}{T_{slot} \cdot N_{users}} \\
& = \frac{52 \times 12 \times (14 - 1) \times 1 \times 2.5664}{0.001 \times 3} \\
& = \boxed{6.94 \,Mbps}
\end{aligned}
$$

