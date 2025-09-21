// SPDX-Licese-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggrigator.sol";

contract Helperconfig is Script {
    NetworkConfig public activeNetworkConfig;
    // If we are on a local Anvil, we deploy the mocks
    // Else, grab the existing address from the live network

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaChainConfig();
        } else if (block.chainid == 300) {
            activeNetworkConfig = getzksynChainConfig();
        } else {
            activeNetworkConfig = getorCreateAnvilChainConfig();
        }
    }

    function getSepoliaChainConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SepoliaConfig;
    }

    function getorCreateAnvilChainConfig() public returns (NetworkConfig memory) {
        //price feed address
        //1.Deploy mocks
        //2. Return the mock address

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockpricefeed)});
        return anvilConfig;
    }

    function getzksynChainConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory zksyncConfig = NetworkConfig({priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF});
        return zksyncConfig;
    }
}
