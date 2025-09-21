// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {deployfundme} from "../../script/Deployfundme.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract Interactiontest is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant START_BALANCE = 10 ether;

    function setUp() external {
        deployfundme Deployfundme = new deployfundme();

        fundme = Deployfundme.run();
        vm.deal(USER, START_BALANCE);
    }

    // function testUserCanFundandInteractions() public {
    //     FundFundMe fundFundmE = new FundFundMe();

    //     vm.deal(USER, 1e18);
    //     vm.prank(USER);
    //     fundFundmE.FundFundme(address(fundme));
    //     address funder = fundme.getfunder(0);

    //     assertEq(funder, USER);
    // }

    function testUserCanWithdrawandInteractions() public {
        FundFundMe fundFundme = new FundFundMe();

        fundFundme.FundFundme(address(fundme));

        WithdrawFundMe withdrawfundme = new WithdrawFundMe();
        withdrawfundme.withdrawFundMe(address(fundme));

        assert(address(fundme).balance == 0);
    }
}
