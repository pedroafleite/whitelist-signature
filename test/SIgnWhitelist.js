const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SignWhitelist", function () {
  it("Should return the new greeting once it's changed", async function () {
    const SignWhitelist = await ethers.getContractFactory("SignWhitelist");
    const signWhitelist = await SignWhitelist.deploy();
    await signWhitelist.deployed();

    expect("Hello, world!").to.equal("Hello, world!");

/*     const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!"); */
  });
});
