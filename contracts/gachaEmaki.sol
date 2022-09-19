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

    uint256 randNonce = 0;

    uint256[] public probabilities;

    struct TokenInfo {
        IERC20 paytoken;
        uint256 costvalue;
    }

    TokenInfo[] public AllowedCrypto;

    function addCurrency(
        IERC20 _paytoken,
        uint256 _costvalue
    ) public onlyOwner {
        AllowedCrypto.push(
            TokenInfo({
                paytoken: _paytoken,
                costvalue: _costvalue
            })
        );
    }

    uint256[] rankTokenB = [HANNYA,TENGU,YOKO];
    uint256[] rankTokenA = [KAMAITACHI,WANYUDO,GYUKI];
    uint256[] rankTokenS = [YAMATANOROCHI,KYUBI];
    uint256[] rankTokenSS = [FUZIN,RAIZIN];

    uint256[][] public rankedTokens = [
        rankTokenB,rankTokenA,rankTokenS,rankTokenSS
    ];
        string public name;
        string public symbol;

    constructor() ERC1155("") {

        name = "MetaYomenClub Emaki";
        symbol = "EMAKI";
        baseMetadataURIPrefix = "https://metayomenclub.herokuapp.com/api/v1/metadata/";
        baseMetadataURISuffix = "/emaki";
        probabilities = [
            50,30,15,5
        ];
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


    function gachaMint(uint256 _pid, uint256 _amount) public payable {
        require(!paused, "gacha : Paused");
        TokenInfo storage tokens = AllowedCrypto[_pid];
        IERC20 paytoken;
        paytoken = tokens.paytoken;
        uint256 cost;
        cost = tokens.costvalue * _amount;
        uint256 allowCost = paytoken.allowance(msg.sender,address(this));
        require(allowCost >= cost * _amount, "Not enough balance to complete transaction");
        paytoken.transferFrom(msg.sender, address(this), cost);

        uint256 num;
        uint256 id;
        for (uint256 i = 1; i <= _amount; i++) {
            num = getRandomNum(msg.sender);
            id = getId(num);
            uint256 mintAmount = 1;
            _mint(msg.sender, id, mintAmount, "");
        }
    }

    function getId(uint256 _num) public returns (uint256){
        uint256 id = _num % 100;
        uint256 probability_b = probabilities[0];
        uint256 probability_a = probabilities[0] + probabilities[1];
        uint256 probability_s = probabilities[0] + probabilities[1]+ probabilities[2];
        uint256 probability_ss = probabilities[0] + probabilities[1] + probabilities[2] + probabilities[3];


        if(0 <= id && id < probability_b){
            uint256 rankB = 0;
            return getRandomFromRank(rankB);
        }else if(probability_b <= id && id < probability_a){
            uint256 rankA = 1;
            return getRandomFromRank(rankA);
        }else if(probability_a <= id && id < probability_s){
            uint256 rankS = 2;
            return getRandomFromRank(rankS);
        }else if(probability_s <= id && id < probability_ss){
            uint256 rankSS = 3;
            return getRandomFromRank(rankSS);
        }
        return 0;
    }

    function getRandomFromRank(uint256 rank) public returns (uint256){
        uint256 len = rankedTokens[rank].length;
        uint256 tokenId = getRandomNum(msg.sender) % len;
        require(rank < rankedTokens.length,"index is over length.");
        return rankedTokens[rank][tokenId];
    }

    function getRandomNum(address _to) public returns (uint256){
        randNonce++;

        uint256 randomNum = uint256(
            keccak256(
                abi.encode(
                    _to,
                    block.timestamp,
                    randNonce
                )
            )
        );
        return randomNum;
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }

    function changeProbabilities(uint256 _pid,uint256 probability) public onlyOwner() {
        probabilities[_pid] = probability;
    }

    function changeCost(
        uint256 _pid,
        uint256 _newCostvalue
    ) public onlyOwner {
        AllowedCrypto[_pid].costvalue = _newCostvalue;
    }


    function pause(bool _state) public onlyOwner() {
        paused = _state;
    }
}
