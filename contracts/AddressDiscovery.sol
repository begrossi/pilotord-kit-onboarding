// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

// Importação do contrato de controle de acesso do OpenZeppelin
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title AddressDiscovery
 * @dev Contrato utilitário para facilitar a descoberta dos demais endereços de contratos na rede do Piloto RD
 */
contract AddressDiscovery is AccessControl {

    // Role de acesso, pertencente a autoridade do contrato.
    bytes32 public constant ACCESS_ROLE = keccak256("ACCESS_ROLE");

    // Mapping do endereço dos contratos, a chave é o hash keccak256 do nome do contrato.
    mapping(bytes32 => address) public addressDiscovery;

    /**
     * @dev Construtor do contrato
     * @param _authority endereço da autoridade do contrato, que pode atualizar os endereços dos contratos
     */
    constructor(address _authority) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(ACCESS_ROLE, keccak256(abi.encodePacked(_authority)));
        _setupRole(ACCESS_ROLE, _authority);
    }

    /**
     * @dev Atualiza o endereço de um contrato. Apenas a autoridade tem permissão para isso.
     * @param smartContract hash keccak256 do nome do contrato
     * @param newAddress novo endereço do contrato
     */
    function updateAddress(bytes32 smartContract, address newAddress) public onlyRole(ACCESS_ROLE) {
        // Atualiza o endereço do contrato
        addressDiscovery[smartContract] = newAddress;
    }
}
