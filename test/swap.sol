// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol";

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../swap.sol";
import "../gacha.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    MetaYomenClub myc;
    Collection gacha;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        myc = new MetaYomenClub();
        gacha = new Collection();
        uint256 tokenLength = 10;
        uint256 tokenId = 0;
        uint256 amount = 10;
        while(tokenId < tokenLength){
            gacha.ownerMint(amount,tokenId);
            gacha.safeTransferFrom(address(gacha), address(myc), tokenId, 10, "");
            tokenId++;
        }
        gacha.ownerMint(12,0);
        gacha.safeTransferFrom(address(gacha), msg.sender, 0, 12, "");

        gacha.setApprovalForAll(address(myc), true);
        myc.swap()



        // uint256[] calldata ids=[0,1,2,3,4,5,6,7,8,9];
        // uint256[] calldata amounts=[10,10,10,10,10,10,10,10,10,10];
        // ids = [0,1,2,3,4,5,6,7,8,9];
        // amounts = [10,10,10,10,10,10,10,10,10,10];

        // <instantiate contract>
        // Assert.equal(uint(1), uint(1), "1 should be equal to 1");
        Assert.equal(myc.FUZIN(), uint256(9), "fuzin token id should be 9");
    }

    function checkSuccess() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.ok(2 == 2, 'should be true');
        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    }

    function checkSuccess2() public pure returns (bool) {
        // Use the return value (true or false) to test the contract
        return true;
    }

    function checkFailure() public {
        Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
