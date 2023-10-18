// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITPFt.sol";
import "./ITPFtDvP.sol";
import "./ITPFtOperation1052.sol";
import "./AddressDiscovery.sol";
import "./RealDigitalDefaultAccount.sol";

contract TPFtOperation1052 is ITPFtOperation1052 {

    mapping(uint256 => Order) private orders;

    AddressDiscovery private addressDiscovery;
    RealDigitalDefaultAccount private realDigitalDefaultAccounts;

    constructor(AddressDiscovery _addressDiscovery, RealDigitalDefaultAccount _realDigitalDefaultAccounts) {
        addressDiscovery = _addressDiscovery;
        realDigitalDefaultAccounts = _realDigitalDefaultAccounts;
    }

    function trade(
        uint256 operationId,
        uint256 cnpj8Sender,
        uint256 cnpj8Receiver,
        CallerPart callerPart,
        ITPFt.TPFtData memory tpftData,
        uint256 tpftAmount,
        uint256 unitPrice
    ) external {
        address sender = realDigitalDefaultAccounts.defaultAccount(cnpj8Sender);
        require(sender != address(0), "Invalid cnpj8Sender");
        address receiver = realDigitalDefaultAccounts.defaultAccount(cnpj8Receiver);
        require(receiver != address(0), "Invalid cnpj8Receiver");

        _trade(operationId, sender, receiver, callerPart, tpftData, tpftAmount, unitPrice);
    }

    function trade(
        uint256 operationId,
        address sender,
        address receiver,
        CallerPart callerPart,
        ITPFt.TPFtData memory tpftData,
        uint256 tpftAmount,
        uint256 unitPrice
    ) external {
        _trade(operationId, sender, receiver, callerPart, tpftData, tpftAmount, unitPrice);
    }

    function _trade(
        uint256 operationId,
        address sender,
        address receiver,
        CallerPart callerPart,
        ITPFt.TPFtData memory tpftData,
        uint256 tpftAmount,
        uint256 unitPrice
    ) internal {
        require(sender != address(0) || receiver != address(0), "Invalid sender or receiver");
        require(sender != receiver, "Sender and Receiver cannot be the same");
        require(operationId>0 && tpftAmount > 0 && unitPrice > 0, "Invalid parameters");

        address tpFtAddress = _getAddress("TPFt");
        address tpFtDvPAddress = _getAddress("TPFtDvP");
        require(tpFtAddress != address(0) && tpFtDvPAddress != address(0), "Contracts not found");
        uint256 financialValue = tpftAmount * unitPrice;

        ITPFt tpFt = ITPFt(tpFtAddress);

        uint256 tokenId = tpFt.getTPFtId(tpftData);
        require(tokenId != 0, "TPFt does not exist");

        Order memory order = orders[operationId];
        if (order.timestamp == 0) {
            // Order doesn't exist, create it
            orders[operationId] = Order(operationId, sender, receiver, callerPart, tokenId, tpftAmount, unitPrice, block.timestamp, OperationStatus.PENDING);
            // emit Event
            emit OperationTradeEvent(
                operationId,
                sender,
                receiver,
                callerPart,
                tpftData,
                tpftAmount,
                unitPrice,
                financialValue,
                "PENDING",
                block.timestamp
            );
        } else {
            // Order exists, attempt to match
            require(order.sender == sender && order.receiver == receiver && order.tokenId == tokenId && order.tpftAmount == tpftAmount && order.unitPrice == unitPrice, "Order does not match");
            require(order.callerPart != callerPart, "CallerPart cannot be the same");
            require(order.status == OperationStatus.PENDING, "Order already executed");

            // Check 1 minute limit
            require(block.timestamp - order.timestamp <= 60, "Order expired");

            ITPFtDvP tpFtDvP = ITPFtDvP(tpFtDvPAddress);
            bool success = tpFtDvP.executeDvP(
                order.sender,
                order.receiver,
                tokenId,
                tpftAmount,
                unitPrice
            );

            order.status = success ? OperationStatus.SUCCESS : OperationStatus.FAILED;

            emit OperationTradeEvent(
                operationId,
                order.sender,
                order.receiver,
                callerPart,
                tpftData,
                tpftAmount,
                unitPrice,
                financialValue,
                success ? "SUCCESS" : "FAILED",
                block.timestamp
            );

        }
    }

    function _getAddress(string memory contractName) private view returns (address) {
        bytes32 id = keccak256(abi.encodePacked(contractName));
        address addr = addressDiscovery.addressDiscovery(id);
        return addr;
    }

}
