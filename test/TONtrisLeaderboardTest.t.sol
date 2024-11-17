// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/TONtrisLeaderboard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockAEON is ERC20 {
    constructor() ERC20("AEON", "AEON") {
        _mint(msg.sender, 1000 * 10 ** 18);  // Mint some AEON for testing
    }
}

contract TONtrisLeaderboardTest is Test {
    TONtrisLeaderboard leaderboard;
    MockAEON aeonToken;

    address player1 = address(0x123);
    address player2 = address(0x456);

    function setUp() public {
        aeonToken = new MockAEON();
        leaderboard = new TONtrisLeaderboard(address(aeonToken));

        // Transfer some AEON to leaderboard for rewards
        aeonToken.transfer(address(leaderboard), 100 * 10 ** 18);
    }

    function testSubmitScoreAndReward() public {
        // Set player1 to submit a score
        vm.startPrank(player1);
        leaderboard.submitScore(100);
        vm.stopPrank();

        // Check leaderboard update
        (address addr, uint256 points) = leaderboard.topScores(0);
        assertEq(addr, player1);
        assertEq(points, 100);

        // Check reward received
        uint256 balance = aeonToken.balanceOf(player1);
        assertEq(balance, 1 * 10 ** 18);  // 1 AEON reward
    }

    function testLeaderboardOrder() public {
        vm.startPrank(player1);
        leaderboard.submitScore(150);
        vm.stopPrank();

        vm.startPrank(player2);
        leaderboard.submitScore(200);
        vm.stopPrank();

        (address addr1, uint256 points1) = leaderboard.topScores(0);
        (address addr2, uint256 points2) = leaderboard.topScores(1);

        assertEq(addr1, player2);
        assertEq(points1, 200);
        assertEq(addr2, player1);
        assertEq(points2, 150);
    }
}
