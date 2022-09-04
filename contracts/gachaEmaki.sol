// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


pragma solidity ^0.8.0;

contract Collection is ERC1155, Ownable {
    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;
    using Strings for uint256;


    constructor() ERC1155("") {
        baseMetadataURIPrefix = "https://staging--goldfish-japan.netlify.app/.netlify/functions/tokenURI/";
        baseMetadataURISuffix = "";
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }
    function ownerMint(uint256 _amount,uint256 _id) public onlyOwner() {
        _mint(msg.sender, _id, _amount, "");
    }

    function publicMint(uint256 _amount) public {
        uint256 id = getRandomId(msg.sender);
        // uint256 id = 1;
        _mint(msg.sender, id, _amount, "");
    }

    function getRandomId(address _to) public view returns (uint256){
        uint256 randomNum = uint256(
            keccak256(
                abi.encode(
                    _to,
                    tx.gasprice,
                    block.number,
                    block.timestamp,
                    block.difficulty,
                    blockhash(block.number - 1),
                    address(this),
                    1
                )
            )
        );
        return randomNum;
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }

}
