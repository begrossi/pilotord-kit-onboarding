// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AddressDiscovery.sol";
import "./ITPFt.sol";
import "./ITPFtDvP.sol";
import "./RealDigital.sol";

contract TPFtDvP is ITPFtDvP {
    AddressDiscovery public addressDiscovery;

    constructor(address _addressDiscovery) {
        addressDiscovery = AddressDiscovery(_addressDiscovery);
    }

    function executeDvP(address sender, address receiver, uint256 tokenId, uint256 tpftAmount, uint256 unitPrice) external payable returns (bool) {
        address tpftAddress = _getAddress("TPFt");
        address realDigitalAddress = _getAddress("RealDigital");
        require(tpftAddress != address(0) && realDigitalAddress != address(0), "Contracts not found");

        RealDigital realDigital = RealDigital(realDigitalAddress);
        ITPFt tpft = ITPFt(tpftAddress);

        // Calcula o valor total da transação
        uint256 totalValue = tpftAmount * unitPrice;

        require(realDigital.balanceOf(receiver) >= totalValue, "Insufficient RealDigital balance");

        // Verifica se o contrato tem permissão para transferir tokens em nome do remetente
        require(tpft.isApprovedForAll(sender, address(this)), "Contract not approved to transfer tokens");

        // Transfere RealDigital do destinatário para o remetente
        bool success = realDigital.transferFrom(receiver, sender, totalValue);
        if (!success) {
            return false;
        }

        // Transfere os tokens TPFt do remetente para o destinatário
        tpft.safeTransferFrom(sender, receiver, tokenId, tpftAmount, "");

        return true;
    }

    function _getAddress(string memory contractName) private view returns (address) {
        return addressDiscovery.addressDiscovery(keccak256(abi.encodePacked(contractName)));
    }
}
