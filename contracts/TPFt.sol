// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./TPFtAccessControl.sol";
import "./ITPFt.sol";

contract TPFt is ITPFt, ERC1155, TPFtAccessControl, Pausable {
    
    mapping(address => uint256) private _frozenBalances;
    mapping(bytes32 => uint256) private _tpFtIds;
    uint256 private _currentId = 1;

    constructor() ERC1155("https://myapi.com/api/token/{id}.json") TPFtAccessControl() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function createTPFt(TPFtData memory tpftData) external onlyRole(MINTER_ROLE) {
        bytes32 key = keccak256(abi.encodePacked(tpftData.acronym, tpftData.code, tpftData.maturityDate));
        require(_tpFtIds[key] == 0, "TPFt already exists");
        _tpFtIds[key] = _currentId;
        _currentId++;
    }

    function mint(address receiverAddress, TPFtData memory tpftData, uint256 tpftAmount) external onlyRole(MINTER_ROLE) {
        uint256 id = _getTPFtId(tpftData);
        require(id != 0, "TPFt does not exist");
        _mint(receiverAddress, id, tpftAmount, "");
    }

    function getTPFtId(TPFtData memory tpftData) external view returns (uint256) {
        return _getTPFtId(tpftData);
    }

    function directPlacement(address from, address to, TPFtData memory tpftData, uint256 tpftAmount) external onlyRole(DIRECT_PLACEMENT_ROLE) {
        uint256 id = _getTPFtId(tpftData);
        require(id != 0, "TPFt does not exist");
        safeTransferFrom(from, to, id, tpftAmount, "");
    }

    function increaseFrozenBalance(address from, TPFtData memory tpftData, uint256 tpftAmount) external onlyRole(FREEZER_ROLE) {
        uint256 id = _getTPFtId(tpftData);
        require(id != 0, "TPFt does not exist");
        _frozenBalances[from] += tpftAmount;
        safeTransferFrom(from, address(this), id, tpftAmount, "");
        emit FrozenBalance(from, _frozenBalances[from]);
    }

    function decreaseFrozenBalance(address from, TPFtData memory tpftData, uint256 tpftAmount) external onlyRole(FREEZER_ROLE) {
        uint256 id = _getTPFtId(tpftData);
        require(id != 0, "TPFt does not exist");
        require(_frozenBalances[from] >= tpftAmount, "Not enough frozen balance");
        _frozenBalances[from] -= tpftAmount;
        safeTransferFrom(address(this), from, id, tpftAmount, "");
        emit FrozenBalance(from, _frozenBalances[from]);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function _getTPFtId(TPFtData memory tpftData) internal view returns (uint256) {
        bytes32 key = keccak256(abi.encodePacked(tpftData.acronym, tpftData.code, tpftData.maturityDate));
        return _tpFtIds[key];
    }

    // Implementing the inherited functions from ERC1155 and AccessControl
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, IERC165, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual override {
        require(!paused(), "ERC1155Pausable: token transfer while paused");
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
