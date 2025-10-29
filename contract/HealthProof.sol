// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthProof {
    // Structure to store patient data
    struct Report {
        string patientName;
        string reportHash; // Hash of medical report stored off-chain (e.g., IPFS)
        uint256 timestamp;
    }

    // Mapping from patient ID to their reports
    mapping(string => Report) private reports;

    // Address of the contract owner (hospital/admin)
    address public owner;

    // Modifier to restrict access
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor runs once when the contract is deployed
    constructor() {
        owner = msg.sender;
    }

    // Function to add or update a patient's report (only by owner)
    function storeReport(
        string memory patientId,
        string memory patientName,
        string memory reportHash
    ) public onlyOwner {
        reports[patientId] = Report({
            patientName: patientName,
            reportHash: reportHash,
            timestamp: block.timestamp
        });
    }

    // Function to verify if a report exists and matches a given hash
    function verifyReport(
        string memory patientId,
        string memory reportHash
    ) public view returns (bool) {
        Report memory report = reports[patientId];
        if (bytes(report.reportHash).length == 0) {
            return false; // No report found
        }
        return keccak256(abi.encodePacked(report.reportHash)) == keccak256(abi.encodePacked(reportHash));
    }

    // Function to view report details (for transparency)
    function getReport(string memory patientId)
        public
        view
        returns (string memory, string memory, uint256)
    {
        Report memory report = reports[patientId];
        require(bytes(report.reportHash).length != 0, "No report found");
        return (report.patientName, report.reportHash, report.timestamp);
    }
}

