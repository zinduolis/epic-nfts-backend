const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);

    //let txn = await nftContract.concatRandomWords();
    // let txn = await nftContract.createImageString("OneTwoTHree");
    // let txn = await nftContract.prepareEncodedJSON("OnThTHr", "data:application/json;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHByZXNlcnZlQXNwZWN0UmF0aW89J3hNaW5ZTWluIG1lZXQnIHZpZXdCb3g9JzAgMCAzNTAgMzUwJz48c3R5bGU+LmJhc2UgeyBmaWxsOiB3aGl0ZTsgZm9udC1mYW1pbHk6IHNlcmlmOyBmb250LXNpemU6IDI0cHg7IH08L3N0eWxlPjxyZWN0IHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIGZpbGw9J2JsYWNrJyAvPjx0ZXh0IHg9JzUwJScgeT0nNTAlJyBjbGFzcz0nYmFzZScgZG9taW5hbnQtYmFzZWxpbmU9J21pZGRsZScgdGV4dC1hbmNob3I9J21pZGRsZSc+T25lVHdvVEhyZWU8L3RleHQ+PC9zdmc+")

    let txn = await nftContract.makeRandomNFTFromIPFS("https://gateway.pinata.cloud/ipfs/QmQjK5jNyeY3BHySKzkHkiK66pdm5gEdnJWQxDkZX7XrbS");
    await txn.wait();

    // txn = await nftContract.makeAnEpicNFT();
    // await txn.wait();
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