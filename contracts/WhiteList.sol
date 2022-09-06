// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


pragma solidity ^0.8.0;

contract WhiteListToken is ERC1155, Ownable {
    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;
    using Strings for uint256;

    string public name;
    string public symbol;

    constructor() ERC1155("") {
        name ="MYC WhiteList";
        symbol = "WL";
        baseMetadataURIPrefix = "https://metayomenclub.herokuapp.com/api/v1/metadata/";
        baseMetadataURISuffix = "/whitelist";
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }
    function ownerMint(uint256 _amount) public onlyOwner() {
        uint256 WhiteListTokenId = 0;
        _mint(msg.sender, WhiteListTokenId, _amount, "");
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }
}
