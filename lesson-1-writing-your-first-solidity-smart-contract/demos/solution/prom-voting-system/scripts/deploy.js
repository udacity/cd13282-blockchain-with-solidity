// Import Hardhat's runtime environment to use its functionalities
const hre = require("hardhat");

async function main() {
  // Fetch the ContractFactory for our PromVoting contract.
  // ContractFactory is a Hardhat abstraction used to deploy new smart contracts.
  const PromVoting = await hre.ethers.getContractFactory("PromVoting");

  // Deploy the contract. This asynchronous operation will wait until the deployment is mined.
  const promVoting = await PromVoting.deploy();

  // Log the address of the newly deployed contract. This is useful for verifying deployment
  // and for interacting with the contract afterwards.
  console.log("PromVoting deployed to:", promVoting.address);
}

// Main function is called and any errors are caught.
// Hardhat recommends this pattern to handle async code in scripts.
main()
  .then(() => process.exit(0)) // On success, exit with a status code 0.
  .catch((error) => {
    console.error(error); // Log any errors that occur.
    process.exit(1); // Exit with a status code 1 indicating an error.
  });
