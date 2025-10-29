# HealthProof
# 🏥 HealthProof – Secure Medical Report Verification on Blockchain

**HealthProof** is a decentralized smart contract built on the **Celo blockchain** to securely store and verify patient medical reports using cryptographic hashes.  
It ensures that patient data remains tamper-proof, transparent, and accessible only by authorized entities such as hospitals or administrators.

---

## 📖 Project Description

In traditional healthcare systems, medical reports are often stored on centralized databases that are vulnerable to tampering, loss, or unauthorized access.  
**HealthProof** addresses this problem by leveraging blockchain technology to ensure **data integrity, privacy, and verification** of medical records.

Each medical report is stored **off-chain** (e.g., on IPFS or cloud) and only its **cryptographic hash** is saved on the blockchain.  
This allows for verification without exposing sensitive data on the public ledger.

---

## ⚙️ What It Does

- Allows hospitals or authorized admins to **store and update** patient medical report metadata on-chain.  
- Enables anyone (patients, doctors, or auditors) to **verify** the authenticity of a medical report using its hash.  
- Provides **transparent access** to report details without compromising patient privacy.  

---

## 🌟 Features

✅ **Decentralized Storage Reference** – Stores only the hash of reports (IPFS, cloud, etc.) on blockchain for security.  
✅ **Immutable Verification** – Verifies if a report hash matches the one recorded on-chain, preventing tampering.  
✅ **Owner-Restricted Access** – Only the contract owner (hospital/admin) can store or update reports.  
✅ **Transparency & Auditability** – Anyone can view report metadata and verify authenticity.  
✅ **Celo Network Integration** – Deployed on the **Celo Sepolia Testnet**, enabling low-cost, eco-friendly transactions.

---

## 🔗 Deployed Smart Contract

**Network:** Celo Sepolia Testnet  
**Contract Address:** [`0x1276524C408d40829c48af0abebb92B07B8eF211`](https://celo-sepolia.blockscout.com/address/0x1276524C408d40829c48af0abebb92B07B8eF211)

You can explore transactions, contract interactions, and event logs using the link above.

---

## 🧠 Smart Contract Overview

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthProof {
    struct Report {
        string patientName;
        string reportHash;
        uint256 timestamp;
    }

    mapping(string => Report) private reports;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

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

    function verifyReport(
        string memory patientId,
        string memory reportHash
    ) public view returns (bool) {
        Report memory report = reports[patientId];
        if (bytes(report.reportHash).length == 0) {
            return false;
        }
        return keccak256(abi.encodePacked(report.reportHash)) == keccak256(abi.encodePacked(reportHash));
    }

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
![App Screenshot]()

