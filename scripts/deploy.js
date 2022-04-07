
const hre = require("hardhat");

async function main() {

  const DaPussNFT = await hre.ethers.getContractFactory("DaPussNFT");
  const daPussNFT = await DaPussNFT.deploy();

  await daPussNFT.deployed();

  console.log("DaPuss deployed to:", daPussNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
