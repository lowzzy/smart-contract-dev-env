// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

pragma solidity ^0.8.0;

contract Collection is ERC721Enumerable, Ownable {


    // function mintPrice(uint256 _tokenId, uint256 _amount) public view returns (uint256) {
    function ofudaCount(address account) public view returns (address) {
        ERC1155 OfudaToken = ERC1155("contract-address");
        OfudaTokenId = 0
        OfudaToken.balanceOf(account, OfudaTokenId);
    }
}
