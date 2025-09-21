// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {deployfundme} from "../../script/Deployfundme.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant START_BALANCE = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployfundme Deployfundme = new deployfundme();
        fundme = Deployfundme.run();
        vm.deal(USER, START_BALANCE);
    }

    function testMinimumUSDisFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsSender() public {
        assertEq(fundme.getOwner(), msg.sender);
    }
    // 1. Unit: Testing a single function
    // 2. Integration: Testing multiple functions
    // 3. Forked: Testing on a forked network
    // 4. Staging: Testing on a live network (testnet or mainnet)

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundfailWhithoutEnoughETH() public {
        vm.expectRevert(); //hey the next line should revert!
        fundme.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        uint256 amountfunded = fundme.getAddesstoAmoundfunded(USER);
        assertEq(amountfunded, SEND_VALUE);
    }

    function testAddsFundersToArryofPeople() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        address funder = fundme.getfunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    function testWIthdrawWithSingleFunder() public funded {
        //Arrange
        uint256 OwnerStartingBalance = fundme.getOwner().balance;
        uint256 StaringBalanceOfFundme = address(fundme).balance;

        //Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        //Assert

        uint256 OwnerEndingbalance = fundme.getOwner().balance;
        uint256 EndingBalanceOfFunde = address(fundme).balance;
        assertEq(EndingBalanceOfFunde, 0);
        assertEq(OwnerStartingBalance + StaringBalanceOfFundme, OwnerEndingbalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberoffunders = 10;
        uint160 fundersIndex = 1;

        for (uint160 i = fundersIndex; i < numberoffunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();

            uint256 OwnerStartingBalance = fundme.getOwner().balance;
            uint256 StaringBalanceOfFundme = address(fundme).balance;

            //act
            vm.startPrank(fundme.getOwner());
            fundme.withdraw();
            vm.stopPrank();

            //assert
            assertEq(address(fundme).balance, 0);
            assertEq(OwnerStartingBalance + StaringBalanceOfFundme, fundme.getOwner().balance);
        }
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // Arrange
        uint160 numberoffunders = 10;
        uint160 fundersIndex = 1;

        for (uint160 i = fundersIndex; i < numberoffunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();

            uint256 OwnerStartingBalance = fundme.getOwner().balance;
            uint256 StaringBalanceOfFundme = address(fundme).balance;

            //act
            vm.startPrank(fundme.getOwner());
            fundme.cheaperWithdraw();
            vm.stopPrank();

            //assert
            assertEq(address(fundme).balance, 0);
            assertEq(OwnerStartingBalance + StaringBalanceOfFundme, fundme.getOwner().balance);
        }
    }
}
