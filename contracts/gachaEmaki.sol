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
    uint256 public constant YAMATANOROCHI = 7;
    uint256 public constant KYUBI = 6;
    // A
    uint256 public constant KAMAITACHI = 5;
    uint256 public constant WANYUDO =4;
    uint256 public constant GYUKI = 3;
    // B
    uint256 public constant HANNYA = 2;
    uint256 public constant TENGU = 1;
    uint256 public constant YOKO = 0;

    uint256 randNonce = 0;

    mapping(uint256=>uint256) public prices;

    uint256[] rankTokenB = [HANNYA,TENGU,YOKO];
    uint256[] rankTokenA = [KAMAITACHI,WANYUDO,GYUKI];
    uint256[] rankTokenS = [YAMATANOROCHI,KYUBI];
    uint256[] rankTokenSS = [FUZIN,RAIZIN];
    // mapping(uint=>uint[4]) public rankedTokens;

    uint256[][] public rankedTokens= [
        rankTokenB,rankTokenA,rankTokenS,rankTokenSS
    ];
        string name;
        string symbol;

    constructor() ERC1155("") {
        name ="sample";
        symbol = "SPL";
        baseMetadataURIPrefix = "";
        baseMetadataURISuffix = "";
        uint256 degit = 1000000000000000000;

        // SS
        prices[FUZIN] = 100 * degit;
        prices[RAIZIN] = 100 * degit;

        // S
        prices[YAMATANOROCHI] = 50 * degit;
        prices[KYUBI] = 50 * degit;

        // A
        prices[KAMAITACHI] = 30 * degit;
        prices[WANYUDO] = 30 * degit;
        prices[GYUKI] = 30 * degit;

        // B
        prices[YOKO] = 10 * degit;
        prices[HANNYA] = 10 * degit;
        prices[TENGU] = 10 * degit;
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

    function publicMint(uint256 _amount) public payable {
        //　指定の価格で買えるような実装をする

    }

    function gachaMint(uint256 _amount) public {
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
        if(0 <= id && id < 50){
            uint256 rankB = 0;
            return getRandomFromRank(rankB);
        }else if(50 <= id && id < 80){
            uint256 rankA = 1;
            return getRandomFromRank(rankA);
        }else if(80 <= id && id < 95){
            uint256 rankS = 2;
            return getRandomFromRank(rankS);
        }else if(95 <= id){
            uint256 rankSS = 3;
            return getRandomFromRank(rankSS);
        }
        // require("ERROR in getId function.");
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
    // 確率いじれるようにする
    }
    function changePrices(uint256 _pid,uint256 price) public onlyOwner() {
        prices[_pid] = price;
    }


}
