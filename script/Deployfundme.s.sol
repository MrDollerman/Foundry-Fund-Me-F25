// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import{Helperconfig} from "./HelperConfig.s.sol";

contract deployfundme is Script {
    function run() external returns (FundMe) { 
        Helperconfig helperconfig = new Helperconfig();
        address ethusdpriceFeed = helperconfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethusdpriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
} 