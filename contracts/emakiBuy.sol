// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


pragma solidity ^0.8.0;

contract BuyEmaki is Ownable {
    using Strings for uint256;

    address emakiAddress = 0xEb139D9A15635832564660E1216B4286481b6373;
    ERC1155 public emaki = ERC1155(emakiAddress);

    // SS
    uint256 public constant FUZIN = 9;
    uint256 public constant RAIZIN = 8;
    // S
    uint256 public constant YAMATANOROCHI = 4;
    uint256 public constant KYUBI = 6;
    // A
    uint256 public constant KAMAITACHI = 2;
    uint256 public constant WANYUDO = 1;
    uint256 public constant GYUKI = 7;
    // B
    uint256 public constant HANNYA = 3;
    uint256 public constant TENGU = 0;
    uint256 public constant YOKO = 5;
    bool public paused;

    uint256[] rankTokenB = [HANNYA,TENGU,YOKO];
    uint256[] rankTokenA = [KAMAITACHI,WANYUDO,GYUKI];
    uint256[] rankTokenS = [YAMATANOROCHI,KYUBI];
    uint256[] rankTokenSS = [FUZIN,RAIZIN];

    uint256[][] public rankedTokens = [
        rankTokenB,rankTokenA,rankTokenS,rankTokenSS
    ];


    function mintCost(uint256 _id) public pure returns (uint256) {
        require(_id < 100, "token is only 100");
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
        return 0;
    }

    function mintTotalCost(uint256[] memory _ids) public pure returns (uint256) {
        uint i = 0;
        uint256 len = _ids.length;
        uint total = 0;
        while(i < len){
            total += mintCost(_ids[i]);
            i+=1;
        }
        return total;
    }


    function changeCost(
        uint256 _pid,
        uint256 _newCostvalue
    ) public onlyOwner {
        // .costvalue = _newCostvalue;
    }

    function transferEmaki(
        address _from,
        address _to,
        uint256 _emakiId,
        uint256 _amount
    ) public {
        emaki.safeTransferFrom(_from, _to, _emakiId, _amount, "");
    }




    function pause(bool _state) public onlyOwner() {
        paused = _state;
    }
}
