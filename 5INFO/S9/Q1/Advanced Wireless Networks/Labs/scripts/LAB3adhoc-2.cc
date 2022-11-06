/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include "ns3/core-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/network-module.h"
#include "ns3/applications-module.h"
#include "ns3/wifi-module.h"
#include "ns3/mobility-module.h"
#include "ns3/mobility-model.h"
#include "ns3/csma-module.h"
#include "ns3/propagation-loss-model.h"
#include "ns3/internet-module.h"
#include "ns3/propagation-delay-model.h"
#include "ns3/wifi-mac-helper.h"
#include "ns3/yans-wifi-channel.h"
#include "ns3/yans-wifi-helper.h"
#include "ns3/olsr-module.h"
#include <string>
#include <iostream>


           
        
using namespace ns3;



NS_LOG_COMPONENT_DEFINE ("LAB3");


int
main (int argc, char *argv[])
{
  bool verbose = true;
  uint32_t nWifi = 6;
  uint32_t payloadSize = 1200;

  CommandLine cmd;
  cmd.AddValue ("nWifi", "Number of wifi STA devices", nWifi);
  cmd.AddValue ("payloadSize", "Size of the application payload in bytes", payloadSize);
  cmd.AddValue ("verbose", "Tell echo applications to log if true", verbose);
  cmd.Parse (argc,argv);

  if (nWifi > 18)
    {
      std::cout << "Number of wifi nodes " << nWifi << 
                   " specified exceeds the mobility bounding box" << std::endl;
      exit (1);
    }

  if (verbose)
    {
      LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
      LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);
    }

  Config::SetDefault ("ns3::TcpSocket::SegmentSize", UintegerValue (payloadSize));

  std::cout << "Running for " << nWifi << " nodes with UDP payload size " << payloadSize << "B" << std::endl;

/////////////////////////////Nodes/////////////////////////////  
  
  NodeContainer nodes;
  nodes.Create (nWifi);

/////////////////////////////Wi-Fi part///////////////////////////// 

  // Creation of the WiFi channel
  Ptr<YansWifiChannel> wifiChannel = CreateObject <YansWifiChannel> ();
  Ptr<TwoRayGroundPropagationLossModel> lossModel = CreateObject<TwoRayGroundPropagationLossModel> ();
  wifiChannel->SetPropagationLossModel (lossModel);
  Ptr<ConstantSpeedPropagationDelayModel> delayModel = CreateObject<ConstantSpeedPropagationDelayModel> ();
  wifiChannel->SetPropagationDelayModel (delayModel);
  
  YansWifiPhyHelper phy; // Physical layer of WiFi
  phy.SetErrorRateModel ("ns3::NistErrorRateModel");
  phy.SetChannel (wifiChannel);

  phy.Set("TxPowerEnd", DoubleValue(16));
  phy.Set("TxPowerStart", DoubleValue(16));
  phy.Set("RxSensitivity", DoubleValue(-80));
  //  phy.Set("CcaMode1Threshold", DoubleValue(-99));
  phy.Set("ChannelNumber", UintegerValue(7));

  // Attach WiFi channel to physical layer (TODO ?)

  // Create WiFi helper
  WifiHelper wifi = WifiHelper();
  wifi.SetStandard (WIFI_PHY_STANDARD_80211b);
  Ssid ssid = Ssid ("wifi-default");
  wifi.SetRemoteStationManager ("ns3::ConstantRateWifiManager", "DataMode",StringValue ("DsssRate1Mbps"), "ControlMode",StringValue ("DsssRate1Mbps"));

/////////////////////////////Devices///////////////////////////// 

  WifiMacHelper mac = WifiMacHelper(); // Mac layer
  mac.SetType ("ns3::AdhocWifiMac");
  NetDeviceContainer devices = wifi.Install (phy, mac, nodes);

/////////////////////////////Deployment///////////////////////////// 

  MobilityHelper mobility;
  Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();

  for(unsigned int i = 0; i < nWifi; i++) {
  	positionAlloc->Add (Vector (200.0 * i, 0.0, 1.0));
  }

  mobility.SetPositionAllocator (positionAlloc);
  mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
  mobility.Install (nodes);

/////////////////////////////Stack of protocols///////////////////////////// 

  
//  Enable OLSR routing
   OlsrHelper olsr;

 //  Install the routing protocol
   Ipv4ListRoutingHelper list;
   list.Add (olsr, 10);

  // Set up internet stack

  InternetStackHelper stack;
  stack.SetRoutingHelper (list);
  stack.Install (nodes);

  // Ipv4GlobalRoutingHelper::PopulateRoutingTables ();

 /////////////////////////////Ip addresation/////////////////////////////  
  
  Ipv4AddressHelper address;
  address.SetBase ("10.1.1.0", "255.255.255.0");
  Ipv4InterfaceContainer interfaces = address.Assign(devices);
  
/////////////////////////////Application part///////////////////////////// 

/*
   uint16_t dlPort = 1000; //Port number
    
  //Sending application on the first station  
  ApplicationContainer onOffApp;
  OnOffHelper onOffHelper("ns3::UdpSocketFactory", InetSocketAddress(interfaces.GetAddress (nWifi-1), dlPort)); //OnOffApplication, UDP traffic,
  onOffHelper.SetAttribute("OnTime", StringValue ("ns3::ConstantRandomVariable[Constant=5000]"));
  onOffHelper.SetAttribute("OffTime", StringValue ("ns3::ConstantRandomVariable[Constant=0]"));
  onOffHelper.SetAttribute("DataRate", DataRateValue(DataRate("10.0Mbps"))); //Traffic Bit Rate
  onOffHelper.SetAttribute("PacketSize", UintegerValue(payloadSize)); // Packet size
  onOffApp.Add(onOffHelper.Install(nodes.Get(0)));  
 
    
  //Opening receiver socket on the last station
  TypeId tid = TypeId::LookupByName ("ns3::UdpSocketFactory");
  Ptr<Socket> recvSink = Socket::CreateSocket (nodes.Get (nWifi-1), tid);
  InetSocketAddress local = InetSocketAddress (interfaces.GetAddress (nWifi-1), dlPort);
  bool ipRecvTos = true;
  recvSink->SetIpRecvTos (ipRecvTos);
  bool ipRecvTtl = true;
  recvSink->SetIpRecvTtl (ipRecvTtl);
  recvSink->Bind (local);
*/

///////////////USE WHEN WORKING WITH TCP TO FILL IN ARP TABLES//////////////////////
  
  UdpEchoServerHelper echoServer (9);

  ApplicationContainer serverApps = echoServer.Install (nodes.Get (nWifi-1));
  serverApps.Start (Seconds (2.0));
  serverApps.Stop (Seconds (6.0));

  UdpEchoClientHelper echoClient (interfaces.GetAddress (nWifi-1), 9);
  echoClient.SetAttribute ("MaxPackets", UintegerValue (100));
  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient.SetAttribute ("PacketSize", UintegerValue (100));

  ApplicationContainer clientApps = echoClient.Install (nodes.Get (0));
  clientApps.Start (Seconds (2.0));
  clientApps.Stop (Seconds (6.0));

/////////////////////////////////////////////////////////////////////////////////

/////////////////////TCP app///////////////////////////
  
  uint16_t port = 50000;
  Address sinkLocalAddress (InetSocketAddress (Ipv4Address::GetAny (), port));
  PacketSinkHelper sinkHelper ("ns3::TcpSocketFactory", sinkLocalAddress);
  ApplicationContainer sinkApp = sinkHelper.Install (nodes.Get (nWifi-1));
  sinkApp.Start (Seconds (10.0));
  sinkApp.Stop (Seconds (100.0));
  // Create the OnOff applications to send TCP to the server (client part)
  OnOffHelper clientHelper ("ns3::TcpSocketFactory", Address ());
  clientHelper.SetAttribute ("OnTime", StringValue ("ns3::ConstantRandomVariable[Constant=1]"));
  clientHelper.SetAttribute("DataRate", DataRateValue(DataRate("10.0Mbps"))); //Traffic Bit Rate
  clientHelper.SetAttribute ("OffTime", StringValue ("ns3::ConstantRandomVariable[Constant=0]"));
  ApplicationContainer clientApp;
      AddressValue clientAddress(InetSocketAddress (interfaces.GetAddress (nWifi-1), port));
      clientHelper.SetAttribute ("Remote", clientAddress);
      clientApp=clientHelper.Install (nodes.Get (0));
      clientApp.Start (Seconds (10.0));
      clientApp.Stop (Seconds (100.0));

////////////////////////////////////////////////////////////


/////////////////////////////Application part///////////////////////////// 

  Simulator::Stop (Seconds (100.0));

/////////////////////////////PCAP tracing/////////////////////////////   

  std::string pcapPrefix = "STA_" + std::to_string(nWifi) + "_" + std::to_string(payloadSize);
  phy.EnablePcap (pcapPrefix, nodes, true);

  Simulator::Run ();
  Simulator::Destroy ();
  
  return 0;
};
