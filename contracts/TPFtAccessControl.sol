// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract TPFtAccessControl is AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant DIRECT_PLACEMENT_ROLE = keccak256("DIRECT_PLACEMENT_ROLE");
    bytes32 public constant AUCTION_PLACEMENT_ROLE = keccak256("AUCTION_PLACEMENT_ROLE");
    bytes32 public constant FREEZER_ROLE = keccak256("FREEZER_ROLE");

    mapping(address => bool) private _enabledAddresses;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function allowTPFtMint(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to assign minter role");
        grantRole(MINTER_ROLE, member);
    }

    function allowDirectPlacement(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to assign direct placement role");
        grantRole(DIRECT_PLACEMENT_ROLE, member);
    }

    function allowAuctionPlacement(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to assign auction placement role");
        grantRole(AUCTION_PLACEMENT_ROLE, member);
    }

    function allowFreezingPlacement(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to assign freezer role");
        grantRole(FREEZER_ROLE, member);
    }

    function enableAddress(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to enable address");
        _enabledAddresses[member] = true;
    }

    function disableAddress(address member) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role to disable address");
        delete _enabledAddresses[member];
    }
    
    function isEnabledAddress(address member) public view returns (bool) {
        return _enabledAddresses[member];
    }
}
