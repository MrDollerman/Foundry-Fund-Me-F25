//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/Fundme.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function FundFundme(address MostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(MostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Fund Fundme with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        FundFundme(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address MostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(MostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        withdrawFundMe(mostRecentlyDeployed);
    }
}
