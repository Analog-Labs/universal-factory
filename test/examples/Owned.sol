// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Context, IUniversalFactory} from "@universal-factory/UniversalFactory.sol";

contract Owned {
    IUniversalFactory internal constant FACTORY = IUniversalFactory(0x000000000000E27221183E5C85058c31DF6a7D01);
    uint256 private immutable IMMUTABLE_VALUE;
    address private _owner;

    // Any value defined in the constructor influences the CREATE2 address.
    constructor(address contractOwner) {
        Context memory ctx = FACTORY.context();
        require(ctx.contractAddress == address(this), "can only be created using Universal Factory");

        // Only the `contractOwner` can create this contract.
        require(ctx.sender == address(contractOwner), "unauthorized");

        // Can initialize immutable, without influecing the create2 address.
        _owner = contractOwner;
        IMMUTABLE_VALUE = abi.decode(ctx.data, (uint256));
    }

    function owner() external view returns (address) {
        return _owner;
    }

    function value() external view returns (uint256) {
        return IMMUTABLE_VALUE;
    }
}
