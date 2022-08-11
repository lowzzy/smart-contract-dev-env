// https://www.youtube.com/watch?v=nZmEI0xKOqA
// 13:30あたりでerc20通貨をerc721コントラクトに送ってmintして、、、みたいな説明をしている

// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

pragma solidity ^0.8.0;

// *********************************************
// 実際にデプロイしたコントラクト
// 0x7b4FA4f2B5cE1ED257163209a81C364ad775D2cd
// *********************************************

contract Collection is ERC721Enumerable, Ownable {

    using Strings for uint256;
    string public baseURI;
    string public baseExtension = ".json";

    bool public paused = false;

    // IERC20 OfudaToken = ERC1155("contract-address");
    address _ofudaAddress = address(0x194a7a55A459507e58b6eA4374940872cD008B20);
    uint256 constant OfudaTokenId = 0;

    ERC1155 OfudaToken = ERC1155(_ofudaAddress);

    // constructor() ERC721("Meta Yomen Club", "MYC") {}
    constructor() ERC721("Meow Yo Club", "MYC") {}

    // ここから下が重要 ******************
    function ofudaCount(address account) public view returns (uint) {
        uint tokenId = 0;
        uint balance = OfudaToken.balanceOf(account, tokenId);
        return balance;
    }

    function ofudaTransfer(address account,uint256 _amount) public returns (uint) {
        uint balance = ofudaCount(account);
        address ownerAddress = owner();
        require(balance >= _amount, "Not enough balance to transfer ofudas");
        OfudaToken.safeTransferFrom(account, ownerAddress,OfudaTokenId, _amount, '');
        return _amount;
    }
    // ここから上が重要 ******************


    // function mint(address _to, uint256 _mintAmount, uint256 _pid) public payable {
    function mint(address _to) public payable {
            // if (msg.sender != owner()) {
            // require(msg.value == cost * _mintAmount, "Not enough balance to complete transaction.");
            // }

            // for (uint256 i = 1; i <= _mintAmount; i++) {
            //     // ここでerc20の通貨をこのアドレスにtransferしてもらっている.
            //     // 1個ずつmintしている
            //     paytoken.transferFrom(msg.sender, address(this), cost);
                _safeMint(_to, 0);
            // }
        }

        function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
        {
            uint256 ownerTokenCount = balanceOf(_owner);
            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for (uint256 i; i < ownerTokenCount; i++) {
                tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return tokenIds;
        }


        function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory) {
            require(
                _exists(tokenId),
                "ERC721Metadata: URI query for nonexistent token"
                );

                string memory currentBaseURI = _baseURI();
                return
                bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
                : "";
        }
        // only owner

        function mintByOwner(address _to, uint256 _mintAmount) public onlyOwner() {
            uint256 supply = totalSupply();
            require(_mintAmount > 0);
            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + i);
            }
        }

        function setBaseURI(string memory _newBaseURI) public onlyOwner() {
            baseURI = _newBaseURI;
        }

        function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
            baseExtension = _newBaseExtension;
        }

        function pause(bool _state) public onlyOwner() {
            paused = _state;
        }

        // function withdraw(uint256 _pid) public payable onlyOwner() {
        //     TokenInfo storage tokens = AllowedCrypto[_pid];
        //     IERC20 paytoken;
        //     paytoken = tokens.paytoken;
        //     paytoken.transfer(msg.sender, paytoken.balanceOf(address(this)));
        // }
}
