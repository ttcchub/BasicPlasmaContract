const hre = require("hardhat");

async function main() {
    const PlasmaChain = await hre.ethers.getContractFactory("PlasmaChain");
    const plasma = await PlasmaChain.deploy();
    await plasma.deployed();

    console.log("✅ Plasma deployed at:", plasma.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
