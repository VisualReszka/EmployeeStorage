// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EmployeeStorage.sol";

contract EmployeeStorageTest is Test {
    EmployeeStorage employeeStorage;

    // Deploy the contract before each test
    function setUp() public {
        employeeStorage = new EmployeeStorage();
    }

    // Test default values
    function testDefaultValues() public view {
        assertEq(employeeStorage.viewShares(), 1000, "Shares should be initialized to 1000");
        assertEq(employeeStorage.viewSalary(), 50000, "Salary should be initialized to 50000");
        assertEq(employeeStorage.name(), "Pat", "Name should be initialized to Pat");
        assertEq(employeeStorage.idNumber(), 112358132134, "ID number should be initialized to 112358132134");
    }

    // Test granting valid shares
    function testGrantSharesValid() public {
        employeeStorage.grantShares(2000);
        assertEq(employeeStorage.viewShares(), 3000, "Shares should increase correctly");

        employeeStorage.grantShares(2000);
        assertEq(employeeStorage.viewShares(), 5000, "Shares should reach the maximum limit");
    }

    function testGrantSharesTooMany() public {
    // Case 1: Adding shares exceeds the maximum limit (should revert)
    vm.expectRevert("Too many shares");
    employeeStorage.grantShares(6000);

    // Case 2: Total shares exceed 5000 (should revert with custom error)
    vm.expectRevert(abi.encodeWithSelector(EmployeeStorage.TooManyShares.selector, 6000));
    employeeStorage.grantShares(5000);
    }


    // Test debugResetShares function
    function testDebugResetShares() public {
        employeeStorage.grantShares(2000); // Shares = 3000
        employeeStorage.debugResetShares(); // Reset shares to 1000
        assertEq(employeeStorage.viewShares(), 1000, "Shares should reset to 1000");
    }

    // Test storage packing via checkForPacking
    function testCheckForPacking() public view {
        uint256 packedSlot = employeeStorage.checkForPacking(0);
        assertTrue(packedSlot != 0, "Packed slot should not be empty");
    }
}

