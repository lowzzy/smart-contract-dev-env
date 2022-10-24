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
    string public name;
    string public symbol;

    constructor() ERC1155("") {
        name = 'MetaYomenClub Ofuda';
        symbol = 'Ofuda';
        baseMetadataURIPrefix = "https://metayomenclub.herokuapp.com/api/v1/metadata/";
        baseMetadataURISuffix = "/ofuda";
    }

    struct TokenInfo {
        IERC20 paytoken;
        uint256 costvalue;
    }

    TokenInfo[] public AllowedCrypto;
    uint256 public stock = 0;
    bool public paused = false;

    using Strings for uint256;

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

    function changeCost(
        uint256 _pid,
        uint256 _newCostvalue
    ) public onlyOwner {
        AllowedCrypto[_pid].costvalue = _newCostvalue;
    }

    function changeStock(
        uint256 _stock
    ) public onlyOwner {
        stock = _stock;
    }

    function pause(bool _state) public onlyOwner() {
            paused = _state;
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

    function publicMint(uint256 _mintAmount, uint256 _pid) public payable {
        require(!paused, "public mint : Paused");
        require(stock >= _mintAmount, "Not enough stock of ofuda");
        TokenInfo storage tokens = AllowedCrypto[_pid];
        IERC20 paytoken;
        paytoken = tokens.paytoken;
        uint256 cost;
        cost = tokens.costvalue;
        require(_mintAmount > 0);
        uint256 allowCost = paytoken.allowance(msg.sender,address(this));
        require(allowCost >= cost * _mintAmount, "Not enough balance to complete transaction");

        paytoken.transferFrom(msg.sender, address(this), cost * _mintAmount);
        _mint(msg.sender, OfudaTokenId, _mintAmount, "");
        stock -= _mintAmount;
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }

    function withdraw(uint256 _pid) public payable onlyOwner() {
            TokenInfo storage tokens = AllowedCrypto[_pid];
            IERC20 paytoken;
            paytoken = tokens.paytoken;
            paytoken.transfer(msg.sender, paytoken.balanceOf(address(this)));
    }
}
