// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TONtrisLeaderboard {
    struct Score {
        address player;
        uint256 points;
    }

    Score[] public topScores;
    uint256 public maxLeaderboardSize = 10;
    IERC20 public aeonToken;

    // Event for new top score
    event NewTopScore(address indexed player, uint256 points);

    constructor(address _aeonToken) {
        aeonToken = IERC20(_aeonToken);
    }

    function submitScore(uint256 points) external {
        // Check if score qualifies for leaderboard
        if (topScores.length < maxLeaderboardSize || points > topScores[topScores.length - 1].points) {
            // Add new score and sort
            topScores.push(Score(msg.sender, points));
            _sortLeaderboard();
            emit NewTopScore(msg.sender, points);

            // Reward player if they qualify
            if (topScores.length <= maxLeaderboardSize) {
                aeonToken.transfer(msg.sender, 1 * 10 ** 18);  // Example reward: 1 AEON
            }

            // Remove lowest score if leaderboard is full
            if (topScores.length > maxLeaderboardSize) {
                topScores.pop();
            }
        }
    }

    // Sort leaderboard in descending order of points
    function _sortLeaderboard() internal {
        for (uint256 i = 0; i < topScores.length - 1; i++) {
            for (uint256 j = i + 1; j < topScores.length; j++) {
                if (topScores[i].points < topScores[j].points) {
                    Score memory temp = topScores[i];
                    topScores[i] = topScores[j];
                    topScores[j] = temp;
                }
            }
        }
    }

    // View leaderboard details
    function getLeaderboard() external view returns (Score[] memory) {
        return topScores;
    }
}
