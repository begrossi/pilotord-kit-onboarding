// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ITPFtDvP
 * @dev Interface for executing Delivery versus Payment (DvP) transactions for a specific token.
 */
interface ITPFtDvP {
    /**
     * @dev Executes a DvP transaction.
     * @param sender The address of the sender.
     * @param receiver The address of the receiver.
     * @param tokenId The ID of the token being transferred.
     * @param tpftAmount The amount of TPFT tokens being transferred.
     * @param unitPrice The unit price of the token being transferred.
     * @return A boolean indicating whether the transaction was successful.
     */
    function executeDvP(address sender, address receiver, uint256 tokenId, uint256 tpftAmount, uint256 unitPrice) external payable returns (bool);
}
