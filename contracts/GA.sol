// SushiItems.sol
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

    //     .                                .
    //     =%=                            =%+
    //      @@@*:          --.         .*@@@.
    //      *@@@@%-    :+#@@@@%+:    -#@@@@#
    //      :@@@@@@@+*@@@@@**@@@@@*+@@@@@@@-
    //       @@@@@@@@@@%+:  -*@@@@@@@@@@@@@
    //       *@@@@@@#=. :+%@@@#=:.-*@@@@@@#
    //   .=#@@@@%+: .-*@@@@*-    -*@@@@%@@@@#=.
    //   @@@@#=. :+%@@@%+:   .=#@@@%+-= .=#@@@@.
    //   @@@* -*@@@@*=.   -*%@@@%=.:%@@    =@@@.
    //   @@@**@@@@@#  .=#@@@%%@@=  :@@@    =@@@.
    //   @@@*--.-@@%*@@@@@+. +@@=  :@@@    -@@@.
    //   @@@*   -@@@@@*@@@=*@@@@=  :@@@    -@@@.
    //   @@@*   -@@%:  @@@@@%%@@=  :@@@    -@@@.
    //   @@@*   -@@#   @@@+. +@@=  :@@@    -@@@.
    //   @@@*   -@@#   @@@+#@@@@=  =@@@    -@@@.
    //   @@@*   -@@#   @@@@@%%@@#*@@@@@    -@@@.
    //   @@@*   -@@#   @@@=.:#@@@@#*@@@    -@@@.
    //   @@@@#=.-@@#   @@@#@@@@*-  :@@@ .-*@@@@.
    //   .=#@@@@@@@# :+@@@@%+:     :@@@%@@@@#+:
    //       -*@@@@@#+*%#=.       -#@@@@@*-
    //          :+#@@@@%+:    :+#@@@@%+:
    //              -*@@@@@**@@@@@*-
    //                 .=#@@@@#=:               MetaYomenClub



contract MetaYomenClub is ERC1155, Ownable{
    uint256[] public numberOfToken;
    // uint256 public wlmintPrice = 0.03 ether;
    // uint256 public mintPrice = 0.05 ether;
    // uint256 private maxMintsPerWL = 5;
    uint256 private maxMintsPerPS = 10;
    uint256 private _totalSupply = 100;
    // bool public whitelistSaleEnabled = false;

    // これ配列にして、idでenabledかどうか判別できる様に
    bool[] public publicSaleEnabled;

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

    mapping(address => uint256) public psMinted;

    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;

    // コントラクトデプロイ時に１度だけ呼ばれる
    constructor() ERC1155("") {
        // 最初は10個GAで出すので
        numberOfToken=[0,0,0,0,0,0,0,0,0,0];
        publicSaleEnabled=[false,false,false,false,false,false,false,false,false,false];

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

    function publicMint(uint256 _tokenId, uint256 _amount) public payable {
        require(publicSaleEnabled[_tokenId], "publicMint: Paused");
        require(maxMintsPerPS >= _amount, "publicMint: 10 maxper tx");
        require(maxMintsPerPS >= psMinted[msg.sender] + _amount, "You have no publicMint left");
        require((_amount + numberOfToken[_tokenId]) <= (_totalSupply), "No more NFTs");
        require(msg.value == mintPrice(_tokenId,_amount), "Value sent is not correct");

        baseMetadataURISuffix = "?is_free=1";
        _mint(msg.sender, _tokenId, _amount, "");
        baseMetadataURISuffix = "?is_free=0";
    }

    function mintPrice(uint256 _tokenId, uint256 _amount) public view returns (uint256) {
        uint256 price = 0;
        uint256 i = 0;
        while(i < _amount){
            if(0 <= numberOfToken[_tokenId] && numberOfToken[_tokenId] <= 50)
            {
                price += 0.001 ether;
            }
            else if(0 <= numberOfToken[_tokenId ]&& numberOfToken[_tokenId] <= 75){
                price += 0.002 ether;
            }
            else if( 0<= numberOfToken[_tokenId] && numberOfToken[_tokenId] <= 88){
                price += 0.003 ether;
            }
            else if( 0<= numberOfToken[_tokenId] && numberOfToken[_tokenId] <= 94){
                price += 0.004 ether;
            }
            else{
                price += 0.005 ether;
            }
            i += 1;
        }
        return price;
    }

    function ownerMint(uint256 _tokenId, uint256 _amount,bool is_paid) public onlyOwner() {
        if(is_paid){
            ChangePaidSuffix();
        }
        _mint(msg.sender, _tokenId, _amount, "");
        if(is_paid){
            ChangeFreeSuffix();
        }
    }

    function ownerMintBatch(uint256[] memory _tokenIds, uint256[] memory _amounts) public onlyOwner(){
        _mintBatch(msg.sender, _tokenIds, _amounts, "");
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }

    function ChangePaidSuffix() public onlyOwner(){
        baseMetadataURISuffix = "?is_free=1";
    }
    function ChangeFreeSuffix() public onlyOwner(){
        baseMetadataURISuffix = "?is_free=0";
    }


    function addNFT(uint256 _tokenId) public onlyOwner(){
        numberOfToken.push(0);
        publicSaleEnabled.push(false);
        _mint(msg.sender, _tokenId, 10, "");
    }

    function setPublicSaleEnabled(uint256 _tokenId, bool _publicSaleEnabled) public onlyOwner(){
        require( _tokenId < publicSaleEnabled.length, "invalid tokenId");
        publicSaleEnabled[_tokenId] = _publicSaleEnabled;
    }

    function withdraw() public onlyOwner {
        uint256 sendAmount = address(this).balance;

        address ownerAddress = payable(0xe277D6aDCaE40ab2Aa72437B8DC0609df6fe135A);

        bool success;

        (success, ) = ownerAddress.call{value: sendAmount}("");
        require(success, "Failed to withdraw Ether");
    }

}
