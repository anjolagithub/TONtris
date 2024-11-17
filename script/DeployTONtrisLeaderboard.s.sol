// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/TONtrisLeaderboard.sol";

contract DeployTONtrisLeaderboard is Script {
    function run() external {
        address aeonTokenAddress = 0x...;  // Replace with AEON token address
        vm.startBroadcast();
        new TONtrisLeaderboard(aeonTokenAddress);
        vm.stopBroadcast();
    }
}
