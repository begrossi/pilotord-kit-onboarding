// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITPFt.sol";

/**
 * @title ITPFtOperation1052
 * @dev Interface for trading operations of TPFt tokens.
 */
interface ITPFtOperation1052 {
    /**
     * @dev Enum to identify the part that is transmitting the command of the operation.
     */
    enum CallerPart {
        TPFtSender,
        TPFtReceiver
    }

    /**
     * @dev Enum to identify the status of the operation.
     */
    enum OperationStatus {
        PENDING,
        SUCCESS,
        FAILED
    }

    /**
     * @dev Struct to represent an order.
     */
    struct Order {
        uint256 operationId;
        address sender;
        address receiver;
        CallerPart callerPart;
        uint256 tokenId;
        uint256 tpftAmount;
        uint256 unitPrice;
        uint256 timestamp;
        OperationStatus status;
    }

    /**
     * @dev Event emitted when a trade operation is executed.
     */
    event OperationTradeEvent(
        uint256 operationId,
        address sender,
        address receiver,
        CallerPart callerPart,
        ITPFt.TPFtData tpftData,
        uint256 tpftAmount,
        uint256 unitPrice,
        uint256 financialValue,
        string status,
        uint256 timestamp
    );

    /**
     * @dev Executes a trade operation.
     * @param operationId The ID of the operation.
     * @param cnpj8Sender The CNPJ8 of the sender.
     * @param cnpj8Receiver The CNPJ8 of the receiver.
     * @param callerPart The part that is transmitting the command of the operation.
     * @param tpftData The TPFt data.
     * @param tpftAmount The amount of TPFt tokens to trade.
     * @param unitPrice The unit price of the TPFt tokens.
     */
    function trade(
        uint256 operationId,
        uint256 cnpj8Sender,
        uint256 cnpj8Receiver,
        CallerPart callerPart,
        ITPFt.TPFtData memory tpftData,
        uint256 tpftAmount,
        uint256 unitPrice
    ) external;

    /**
     * @dev Executes a trade operation.
     * @param operationId The ID of the operation.
     * @param sender The address of the sender.
     * @param receiver The address of the receiver.
     * @param callerPart The part that is transmitting the command of the operation.
     * @param tpftData The TPFt data.
     * @param tpftAmount The amount of TPFt tokens to trade.
     * @param unitPrice The unit price of the TPFt tokens.
     */
    function trade(
        uint256 operationId,
        address sender,
        address receiver,
        CallerPart callerPart,
        ITPFt.TPFtData memory tpftData,
        uint256 tpftAmount,
        uint256 unitPrice
    ) external;
}
