const hre = require("hardhat");

async function main() {
  const SignWhitelist = await hre.ethers.getContracnptFactory("SignWhitelist");
  const signWhitelist = await SignWhitelist.deploy("Hello, Hardhat!");

  await signWhitelist.deployed();

  console.log("SignWhitelist deployed to:", signWhitelist.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
