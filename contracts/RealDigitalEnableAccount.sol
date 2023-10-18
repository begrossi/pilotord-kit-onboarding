// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./CBDCAccessControl.sol";

/**
 * @title RealDigitalEnableAccount
 * @dev Contrato que permite ao participante habilitar outras carteiras de sua propriedade.
 */
contract RealDigitalEnableAccount {
    CBDCAccessControl private accessControl; // Referência ao contrato de controle de acesso.

    /**
     * @dev Construtor do contrato
     * @param accessControlAddress Endereço do contrato de controle de acesso. O construtor cria uma instância do contrato e armazena este endereço.
     */
    constructor(address accessControlAddress) {
        accessControl = CBDCAccessControl(accessControlAddress);
    }

    /**
     * @dev Habilita uma nova carteira para o participante. Qualquer carteira previamente habilitada para o participante pode habilitar outras carteiras.
     * @param member Novo endereço do participante.
     */
    function enableAccount(address member) public {
        require(accessControl.verifyAccount(msg.sender), "Must be participant");
        accessControl.enableAccount(member);
    }

    /**
     * @dev Desabilita a própria carteira que executou a função.
     */
    function disableAccount() public {
        require(accessControl.verifyAccount(msg.sender), "Must be participant");
        accessControl.disableAccount(msg.sender);
    }
}
