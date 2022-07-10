// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "ds-test/test.sol";

import "../src/MarketNG.sol";
import "../src/IWETH.sol";
import "../src/mocks/MockERC20.sol";
import "../src/mocks/MockERC721.sol";

import {console} from "forge-std/console.sol";

contract MarketNGTest is Test {

    address constant alice = address(0x1111);
    address constant bob = address(0x1337);

    using stdStorage for StdStorage;

    IWETH public iweth;
    MarketNG public marketNG;
    MockERC20 public mockERC20;
    MockERC721 public mockERC721;

    function setUp() public {
        ////// deploy contracts
        // MarketNG
        marketNG = new MarketNG(iweth);
        marketNG.pause();
        marketNG.unpause();


        // MockERC20
        mockERC20 = new MockERC20();

        // MockERC721
        mockERC721 = new MockERC721();
        deal(address(mockERC721), alice, 1);

        ////// verify setup
        // market
        assertEq(marketNG.RATE_BASE(), 1e6);

        // ERC20
        assertEq(mockERC20.balanceOf(alice), 1_000_000e18);

        //ERC721
        assertEq(mockERC721.balanceOf(alice), 1);

        emit log_address(bob);
        emit log_address(alice);
        console2.log("Hello world!");
    }

    // swap erc721 for erc721 fuzz
    function testCreateSwap(MarketNG.Swap memory req, bytes memory signature) public {
        vm.startPrank(alice);
        mockERC721.mintItem("testURI");
        uint256 slotBalance = stdstore
            .target(address(mockERC721))
            .sig(mockERC721.balanceOf.selector)
            .with_key(alice)
            .find();
        uint256 balance = uint256(vm.load(address(mockERC721), bytes32(slotBalance)));
        assertEq(balance, 1);

        //marketNG.swap(req, signature);

        vm.stopPrank();
        emit log_string("Hello world!");
    }
    function testPausing(MarketNG.Swap memory req, bytes memory signature) public {
        vm.startPrank(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84); // foundry deployer address
        marketNG.pause();
        assertTrue(marketNG.paused());
        marketNG.unpause();
        marketNG.swap(req, signature);
        vm.stopPrank();
    }

    function testRunTx(
        MarketNG.Intention calldata intent,
        MarketNG.Detail calldata detail,
        bytes calldata sigIntent,
        bytes calldata sigDetail
    ) public {
        vm.startPrank(alice);
        //marketNG.run(intent, detail, sigIntent, sigDetail);
        vm.stopPrank();

    }

}
