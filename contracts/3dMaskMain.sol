// SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

pragma solidity ^0.8.0;

contract Collection is ERC721Enumerable, Ownable {
    constructor() ERC721("Sample", "SPL") {}

    address wethAddress = 0x5cEa23FbEEA919DeF8bB6c7410B7947a22a092FC;
    IERC20 public paytoken = IERC20(wethAddress);
    address whiteListAddress = 0xEb139D9A15635832564660E1216B4286481b6373;
    ERC1155 public wl = ERC1155(whiteListAddress);

    uint256 public constant RankSScost = 0.1 ether;
    uint256 public constant RankScost = 0.2 ether;
    uint256 public constant RankAcost = 0.3 ether;
    uint256 public constant RankBcost = 0.4 ether;
    uint256 public constant RankCcost = 0.5 ether;

    mapping(address => bool) public wlUsed;

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

    function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://EE5MmqVp5MmqVp7ZRMBBizicVh9ficVh9fjUofWicVh9f/";
    }

    // idが0からじゃないなあ、、
    function ownerMint(uint256 _amount) public onlyOwner() {
        uint256 supply = totalSupply();
        for (uint256 i = 1; i <= _amount; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function setUsedWhiteList(address _account) private {
        wlUsed[_account] = true;
    }

    function preMint(uint256[] memory _ids) public payable {
        uint256 whiteListId = 0;
        uint256 wlBalance = wl.balanceOf(msg.sender, whiteListId);

        // require(wlBalance > 0 || wlUsed[msg.sender], "msg.sender has no WhiteList.");
        require(wlBalance > 0 , "msg.sender has no WhiteList.");
        // if(wlBalance > 0){
        //     setUsedWhiteList(msg.sender);
            uint256 amount = 1;
            wl.safeTransferFrom(msg.sender, owner(), whiteListId, amount, "");
        // }
        // bool isAppreved = wl.isApprovedForAll(msg.sender, owner());
        // require(isAppreved, "whitelist is not approved.");

        uint256 cost;
        cost = mintTotalCost(_ids);

        uint256 allowCost = paytoken.allowance(msg.sender,address(this));
        require(allowCost >= cost, "Not enough balance to complete transaction.");

        paytoken.transferFrom(msg.sender, address(this), cost);
        uint256 len = _ids.length;
        for (uint256 i = 0; i < len; i++) {
            _safeMint(msg.sender, _ids[i]);
        }
    }

    function withdraw() public payable onlyOwner() {
        paytoken.transfer(msg.sender, paytoken.balanceOf(owner()));
    }

}
