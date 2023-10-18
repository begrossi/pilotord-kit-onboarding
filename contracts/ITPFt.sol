// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**
 * @title ITPFt
 * @dev Esta interface representa as funções externas do contrato `TPFt`, que é um token ERC1155 representando um Título Público Federal tokenizado (TPFt).
 */

interface ITPFt is IERC1155 {

    /**
     * @dev Estrutura representando os dados associados a um TPFt.
     */
    struct TPFtData {
        string acronym;      // Sigla do TPFt.
        string code;         // Código único associado ao TPFt.
        uint256 maturityDate; // Data de vencimento do TPFt em formato timestamp.
    }

    /**
     * @dev Evento emitido quando o saldo congelado de um endereço é atualizado.
     * @param from Endereço cujo saldo congelado foi atualizado.
     * @param balance O saldo congelado atualizado.
     */
    event FrozenBalance(address indexed from, uint256 balance);

    /**
     * @dev Função para criar um novo TPFt.
     * @param tpftData Dados associados ao TPFt a ser criado.
     */
    function createTPFt(TPFtData memory tpftData) external;

    /**
     * @dev Função para emitir (mint) um TPFt para um endereço específico.
     * @param receiverAddress Endereço que receberá o TPFt.
     * @param tpftData Dados associados ao TPFt a ser emitido.
     * @param tpftAmount Quantidade de TPFt a ser emitida.
     */
    function mint(address receiverAddress, TPFtData memory tpftData, uint256 tpftAmount) external;

    /**
     * @dev Função para obter o ID de um TPFt específico.
     * @param tpftData Dados associados ao TPFt cujo ID é solicitado.
     * @return O ID do TPFt.
     */
    function getTPFtId(TPFtData memory tpftData) external view returns (uint256);

    /**
     * @dev Função para realizar uma colocação direta de um TPFt de um endereço para outro.
     * @param from Endereço de origem da colocação.
     * @param to Endereço de destino da colocação.
     * @param tpftData Dados associados ao TPFt a ser colocado.
     * @param tpftAmount Quantidade de TPFt a ser colocada.
     */
    function directPlacement(address from, address to, TPFtData memory tpftData, uint256 tpftAmount) external;

    /**
     * @dev Função para aumentar o saldo congelado de um endereço.
     * @param from Endereço cujo saldo será congelado.
     * @param tpftData Dados associados ao TPFt a ser congelado.
     * @param tpftAmount Quantidade de TPFt a ser congelada.
     */
    function increaseFrozenBalance(address from, TPFtData memory tpftData, uint256 tpftAmount) external;

    /**
     * @dev Função para diminuir o saldo congelado de um endereço.
     * @param from Endereço cujo saldo será descongelado.
     * @param tpftData Dados associados ao TPFt a ser descongelado.
     * @param tpftAmount Quantidade de TPFt a ser descongelada.
     */
    function decreaseFrozenBalance(address from, TPFtData memory tpftData, uint256 tpftAmount) external;

    /**
     * @dev Função para pausar todas as operações do contrato.
     */
    function pause() external;

    /**
     * @dev Função para retomar todas as operações do contrato após terem sido pausadas.
     */
    function unpause() external;
}
