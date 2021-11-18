const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('EthernalInitials');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.mintNFT(0)
  // Wait for it to be mined.
  await txn.wait()
  const uri = await nftContract.tokenURI(0)
  console.log(uri)

  // Mint another NFT for fun.
  txn = await nftContract.mintNFT(102)
  // Wait for it to be mined.
  await txn.wait()

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();