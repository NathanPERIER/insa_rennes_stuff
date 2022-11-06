---
tags: LTU, AWN
---

# Lab 0 - Introduction to ns-3

Nathan PERIER, Aldo COLOMBO

## Question 1

> What are the alternatives for installing ns-3 under different operating systems ?

First, we must download the source code. For this, we have three options :

1. Download a compressed archive containing the source code from the [nsnam.org release page](https://www.nsnam.org/releases/), and then uncompress it with tools such as `tar` or 7-Zip.
2. Clone the [`nsnam/ns-3-allinone` gitlab repository](https://gitlab.com/nsnam/ns-3-allinone) and use the `download.py` utilitary.
3. Use [Bake](https://gitlab.com/nsnam/bake.git), which is a software designed by the ns-3 team to build sources from several repositories and manage versions

Then, we need to build the sources, which can be done :

- Using the `build.py` utilitary included with the sources
- With Bake (also included with the sources for recent versions)

## Question 2

> Write a step-by-step instruction for creating a simulation scenario, i.e. first we create ...

1. First, we must create some machines represented by `Node` objects (more specifically, objects whose class is a subclass of `Node`). This can be done with the [`NodeContainer`](https://www.nsnam.org/doxygen/classns3_1_1_node_container.html) helper.
2. Then, in order to enable the `Nodes` to communicate, we must give them network interfaces (`NetDevices`) and link them together with `Channels`. Once again, this can be done with a helper such as the [`PointToPointHelper`](https://www.nsnam.org/doxygen/classns3_1_1_point_to_point_helper.html). The helper also enables us to set various properties (`Attributes`) of the `NetDevices` and the `Channels`.
3. Next, we must give the `Nodes` network protocols to comminucate with. The [`InternetStackHelper`](https://www.nsnam.org/doxygen/classns3_1_1_internet_stack_helper.html) can be used to install a classic Internet stack with IP, TCP and UDP protocols.
4. In the case we have a network stack that uses IP, we must give the machines an IP adress. For IPv4, this is done via the [`Ipv4AddressHelper`](https://www.nsnam.org/doxygen/classns3_1_1_ipv4_address_helper.html).
5. After that, we must install applications on our nodes to send and recieve data via the network stack (in the form of `Application` objects). For each `Application`, we must schedule a start time and optionally a stop time. Once again, this process can be simplified via some helpers, that can also allow us to configure `Attributes`.
6. Finally, we can start the simulation with `Simulator::Run();`, followed by `Simulator::Destroy();` for cleanup. If needed, we can shedule a stop time for the simultation with `Simulator::Stop(Seconds(n));` (before the `Run` call).

## Question 3

> If you needed to simulate a protocol which is not inside the ns-3 library, what would you need to do ?

If we want to use a protocol which is not in the ns-3 library, we need to implement it ourselves in C++.

## Question 4

> For compiling an ns-3 executable, a special build system is used. What is this system ?

To compile an ns-3 script, we use the python-based build system Waf. It is presented as an alternative to other build systems like Make for example, but with some notable differences :

- It is written in pure Python, no additional language is used (and there are no software dependencies)
- It doesn't use build files like Makefiles


## Question 5

> Describe the purpose of different (only main) folders of the ns-3 distribution.

- `src` : ns-3 source code
- `examples` : example scripts using ns-3 to simulate various network configurations
- `scratch` : folder in which we place C++ scripts to be built by Waf
- `build` : destination folder for compiled code

## Question 6

> Which folder should contain your simulation scripts ?

Our scripts' sources should be in the `scratch` folder so that we can easily build them with `./waf` when needed. The compiled executables will then be in the `build/scratch` folder.

## Question 7

> Write a step-by step instruction for executing an ns-3 simulation.

1. Write the simulation script according to Q.2 (e.g. in `scratch/myscript.cc`)
2. `./waf`
3. `./waf --run myscript`

## Question 8

> In how many formats does ns-3 saves the results (traces) of a simulation ? Name them.
> What are the major differences ?

The traces can be saved in two formats :

 - **ASCII**: a textual format which is specific to the ns project. We have to parse it if we want to extract information.
 - **PCAP**: a standardised binary format that is compatible with several softwares like Wireshark.

## Question 9

> When you run your simulation, in which folder you will find the simulation traces ?

The traces are saved in the root folder of ns-3 (in our case, `~/ns-allinone-3.34/ns-3.34`).

