// SushiItems.sol
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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



contract Ofuda is ERC1155, Ownable{
    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;

    uint256 constant OfudaTokenId = 0;

    constructor() ERC1155("") {
        baseMetadataURIPrefix = "https://staging--goldfish-japan.netlify.app/.netlify/functions/tokenURI/";
        baseMetadataURISuffix = "";
    }

    struct TokenInfo {
        IERC20 paytoken;
        uint256 costvalue;
    }

    TokenInfo[] public AllowedCrypto;

    using Strings for uint256;

    // ここでonly ownerでNFTをmintするための通貨を定義している
    // 25:20~
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

    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }

    function ownerMint(uint256 _amount) public onlyOwner() {
        _mint(msg.sender, OfudaTokenId, _amount, "");
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }
}