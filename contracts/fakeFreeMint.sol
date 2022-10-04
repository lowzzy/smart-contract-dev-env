// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";


pragma solidity ^0.8.0;

contract YomenGirlFreeMint is  Ownable, ERC1155Receiver {
    ERC1155 Girl = ERC1155(0x5cEa23FbEEA919DeF8bB6c7410B7947a22a092FC);
    // ERC1155 Girl = ERC1155(/**ここにコントラクトアドレス入れる*/);
    mapping(address => uint256) public addressMintedBalance;
    uint256 public maxSupply;
    uint256 public supply = 0;
    bool public paused = false;

    function imitateMint(uint256 _tokenId) public {
        uint256 mintAmount = 1;
        require(!paused, "the contract is paused");
        require(supply + mintAmount <= maxSupply, "max NFT limit exceeded");
        require(supply + mintAmount <= tokenBalance(_tokenId), "Not enough stock");
        require(addressMintedBalance[msg.sender] == 0, "1 token per wallet");

        Girl.safeTransferFrom(address(this), msg.sender, _tokenId, mintAmount,"");
        addressMintedBalance[msg.sender]++;
        supply++;
    }

    function changeMaxSupply(uint256 _newSupply) public {
        maxSupply = _newSupply;
    }
    function tokenBalance(uint256 _tokenId) public view returns (uint256) {
        return Girl.balanceOf(address(this), _tokenId);
    }
    function pause(bool _state) public onlyOwner() {
            paused = _state;
        }

}
