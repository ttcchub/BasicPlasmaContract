require("dotenv").config();
const hre = require("hardhat");
const { ethers } = hre;

async function main() {
    const contractAddress = process.env.CONTRACT_ADDRESS;
    const { ethers } = hre;  // 👈 ОБЯЗАТЕЛЬНО, чтобы parseEther работал

    const [signer] = await ethers.getSigners();

    const plasma = await ethers.getContractAt("PlasmaChain", contractAddress, signer);

    console.log("💸 Sending deposit...");
    const tx1 = await plasma.deposit({ value: ethers.utils.parseEther("0.01") });
    await tx1.wait();

    const rootHash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("fake block"));
    console.log("📦 Submitting plasma block...");
    const tx2 = await plasma.submitBlock(rootHash);
    await tx2.wait();

    console.log("🚪 Exiting funds...");
    const tx3 = await plasma.exit(1);
    await tx3.wait();

    console.log("✅ Done!");
}

main().catch(console.error);
