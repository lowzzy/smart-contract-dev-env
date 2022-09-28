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
    string public baseMetadataURIPrefix;
    string public baseMetadataURISuffix;
    string public contractURI;
    string public name;
    string public symbol;

    constructor() ERC1155("") {
        baseMetadataURIPrefix = "https://metayomenclub.herokuapp.com/api/v1/metadata/";
        baseMetadataURISuffix = "/avatar";
        contractURI = "https://metayomenclub.herokuapp.com/api/v1/contract_metadata/0/avatar";
    }


    function uri(uint256 _id) public view override returns (string memory) {
        return string(abi.encodePacked(
            baseMetadataURIPrefix,
            Strings.toString(_id),
            baseMetadataURISuffix
        ));
    }

    function ownerMint(uint256 _tokenId, uint256 _amount) public onlyOwner() {
        _mint(msg.sender, _tokenId, _amount, "");
    }

    function ownerMintBatch(uint256[] memory _tokenIds, uint256[] memory _amounts) public onlyOwner(){
        _mintBatch(msg.sender, _tokenIds, _amounts, "");
    }

    function setBaseMetadataURI(string memory _prefix, string memory _suffix) public onlyOwner(){
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }
    function setContractURI(string memory _newContractURI) public onlyOwner(){
        contractURI = _newContractURI;
    }
}
