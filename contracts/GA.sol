// SushiItems.sol
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MetaYomenClub is ERC1155, Ownable{
    // わかりやすく数字を文字列で表している
    uint256 public constant TENGU = 0;
    uint256 public constant YOKO = 1;
    uint256 public constant KAMAITACHI = 2;
    uint256 public constant WANYUDO = 3;
    uint256 public constant GYUKI = 4;
    uint256 public constant KYUBI = 5;
    uint256 public constant YAMATANOROCHI = 6;
    uint256 public constant HANNYA = 7;
    uint256 public constant HITOTSUMEKOZO = 8;
    uint256 public constant DEIDARABOCHI = 9;

    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;

    // コントラクトデプロイ時に１度だけ呼ばれる
    constructor() ERC1155("") {
        baseMetadataURIPrefix = "https://metayomenclub.herokuapp.com/api/v1/metadata/";
        baseMetadataURISuffix = "?is_free=0";

	// tokenID 0 を 100個 発行する。　
	// デフォルトの所有者は msg.sender (コントラクトをデプロイした人）
        _mint(msg.sender, TENGU, 10, "");
        _mint(msg.sender, YOKO, 10, "");
        _mint(msg.sender, KAMAITACHI, 10, "");
        _mint(msg.sender, WANYUDO, 10, "");
        _mint(msg.sender, GYUKI, 10, "");
        _mint(msg.sender, KYUBI, 10, "");
        _mint(msg.sender, YAMATANOROCHI, 10, "");
        _mint(msg.sender, HANNYA, 10, "");
        _mint(msg.sender, HITOTSUMEKOZO, 10, "");
        _mint(msg.sender, DEIDARABOCHI, 10, "");
    }


    function uri(uint256 _id) public view override returns (string memory) {
        // "https://~~~" + tokenID + ".json" の文字列結合を行っている
	// OpenSeaはここのメタデータを読み取ることで画像等を表示している
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }

    function mint(uint256 _tokenId, uint256 _amount) public onlyOwner() {
        _mint(msg.sender, _tokenId, _amount, "");
    }

    function mintBatch(uint256[] memory _tokenIds, uint256[] memory _amounts) public onlyOwner(){
        _mintBatch(msg.sender, _tokenIds, _amounts, "");
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }
}
