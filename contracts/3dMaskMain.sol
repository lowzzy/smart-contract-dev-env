// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

pragma solidity ^0.8.0;

contract Collection is ERC721Enumerable, Ownable {
    constructor() ERC721("Sample", "SPL") {}


    // TokenInfo[] public AllowedCrypto;
    // // ここでonly ownerでNFTをmintするための通貨を定義している
    // // 25:20~
    // function addCurrency(
    //     IERC20 _paytoken,
    //     uint256 _costvalue
    // ) public onlyOwner {
    //     AllowedCrypto.push(
    //         TokenInfo({
    //             paytoken: _paytoken,
    //             costvalue: _costvalue
    //         })
    //     );
    // }

    address wethAddress = 0x5cEa23FbEEA919DeF8bB6c7410B7947a22a092FC;
    IERC20 public paytoken = IERC20(wethAddress);


    uint256 public constant RankSScost = 0.1 ether;
    uint256 public constant RankScost = 0.2 ether;
    uint256 public constant RankAcost = 0.3 ether;
    uint256 public constant RankBcost = 0.4 ether;
    uint256 public constant RankCcost = 0.5 ether;

    function mintCost(uint256 _id) public pure returns (uint256) {
        require(_id <= 100, "token is only 100");
        if(0 <= _id && _id < 20 ){
            return RankSScost;
        }else if(20 <= _id && _id < 40 ){
            return RankScost;
        }else if(40 <= _id && _id < 60 ){
            return RankAcost;
        }else if(60 <= _id && _id < 80 ){
            return RankBcost;
        }else if(80 <= _id && _id < 100 ){
            return RankCcost;
        }
        return RankAcost;
    }

    function mintTotalCost(uint256[] ids) public pure returns (uint256) {
        uint i = 0;
        uint256 len = ids.length;
        uint total = 0;
        while(i < len){
            total += mintCost(ids[i]);
            i+=1;
        }
        return total;
    }

    struct TokenInfo {
        IERC20 paytoken;
        uint256 costvalue;
    }


    function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://EE5MmqVp5MmqVp7ZRMBBizicVh9ficVh9fjUofWicVh9f/";
    }

    // idが0からじゃないなあ、、
    function ownerMint(uint256 _amount) public onlyOwner() {
        uint256 supply = totalSupply();
        for (uint256 i = 1; i <= _amount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function preMint(uint256 _amount, uint256 _pid) public payable {
        TokenInfo storage tokens = AllowedCrypto[_pid];
        // IERC20 paytoken; // ここで使う通貨を定義している
        // paytoken = tokens.paytoken; // 実際に通貨を代入しているのはここ
        paytoken
        id
        uint256 cost = 0;
        cost = mintTotalCost(ids);
        require(_amount > 0);
        uint256 allowCost = paytoken.allowance(msg.sender,address(this));
        require(allowCost >= cost * _amount, "Not enough balance to complete transaction.");

        paytoken.transferFrom(msg.sender, address(this), cost * _amount);
        uint256 supply = totalSupply();
        for (uint256 i = 1; i <= _amount; i++) {
            _safeMint(msg.sender, supply + i);
        }
  }

    function withdraw(uint256 _pid) public payable onlyOwner() {
            TokenInfo storage tokens = AllowedCrypto[_pid];
            IERC20 paytoken;
            paytoken = tokens.paytoken;
            paytoken.transfer(msg.sender, paytoken.balanceOf(address(this)));
    }


}
