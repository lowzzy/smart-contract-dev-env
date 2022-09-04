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
    uint256 public constant FUZIN = 8;
    uint256 public constant RAIZIN = 9;
    // S
    uint256 public constant YAMATANOROCHI = 6;
    uint256 public constant KYUBI = 5;
    // A
    uint256 public constant KAMAITACHI = 2;
    uint256 public constant WANYUDO = 3;
    uint256 public constant GYUKI = 4;
    // B
    uint256 public constant HANNYA = 7;
    uint256 public constant TENGU = 0;
    uint256 public constant YOKO = 1;


    uint256[] rankTokenB = [HANNYA,TENGU,YOKO];
    uint256[] rankTokenA = [KAMAITACHI,WANYUDO,GYUKI];
    uint256[] rankTokenS = [YAMATANOROCHI,KYUBI];
    uint256[] rankTokenSS = [FUZIN,RAIZIN];
    mapping(uint=>uint[4]) public rankedTokens = [
        rankTokenB,
        rankTokenA,
        rankTokenS,
        rankTokenSS
    ];

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
        uint256 num = getRandomNum(msg.sender);
        // uint256 id = 1;
        uint256 id = getId(num);
        _mint(msg.sender, id, _amount, "");
    }

    function getId(uint256 _num) public view returns (uint256){
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

    function getRandomFromRank(uint256 rank) public view returns (uint256){
        uint256 len = rankedTokens[rank].length;
        uint256 tokenId = getRandomNum % len;
        require(rank < rankedTokens.length,"index is over length.");
        return rankedTokens[rank][tokenId];
    }

    function getRandomNum(address _to) public view returns (uint256){
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
