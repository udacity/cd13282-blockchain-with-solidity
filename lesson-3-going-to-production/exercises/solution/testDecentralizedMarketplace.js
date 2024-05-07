const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DecentralizedMarketplace", function () {
  async function deployMarketplaceFixture() {
    const [owner, buyer, addr1] = await ethers.getSigners();
    const Marketplace = await ethers.getContractFactory(
      "DecentralizedMarketplace"
    );
    const marketplace = await Marketplace.deploy();
    return { marketplace, owner, buyer, addr1 };
  }

  describe("Listing items", function () {
    it("Should list an item successfully", async function () {
      const { marketplace, owner } = await loadFixture(
        deployMarketplaceFixture
      );
      await marketplace
        .connect(owner)
        .listItem("Canvas Art", ethers.parseEther("1"));
      const item = await marketplace.getItem(1);
      expect(item.name).to.equal("Canvas Art");
      expect(item.price.toString()).to.equal(ethers.parseEther("1").toString());
      expect(item.available).to.equal(true);
    });
  });

  describe("Purchasing items", function () {
    it("Should allow a buyer to purchase an item", async function () {
      const { marketplace, owner, buyer } = await loadFixture(
        deployMarketplaceFixture
      );
      await marketplace
        .connect(owner)
        .listItem("Vintage Lamp", ethers.parseEther("0.5"));
      await marketplace
        .connect(buyer)
        .purchaseItem(1, { value: ethers.parseEther("0.5") });
      const item = await marketplace.getItem(1);
      expect(item.available).to.equal(false);
    });

    it("Should fail if buyer tries to buy their own item", async function () {
      const { marketplace, owner } = await loadFixture(
        deployMarketplaceFixture
      );
      await marketplace
        .connect(owner)
        .listItem("Book", ethers.parseEther("0.1"));
      await expect(
        marketplace
          .connect(owner)
          .purchaseItem(1, { value: ethers.parseEther("0.1") })
      ).to.be.revertedWith("Seller cannot buy their own item");
    });
  });

  describe("Adding reviews", function () {
    it("Should allow adding a review", async function () {
      const { marketplace, owner, buyer } = await loadFixture(
        deployMarketplaceFixture
      );
      await marketplace
        .connect(owner)
        .listItem("Coffee Mug", ethers.parseEther("0.1"));
      await marketplace
        .connect(buyer)
        .purchaseItem(1, { value: ethers.parseEther("0.1") });
      await marketplace.connect(buyer).addReview(1, "Great mug", 5);
      const reviews = await marketplace.getReviews(1);
      expect(reviews.length).to.equal(1);
      expect(reviews[0].comment).to.equal("Great mug");
      expect(reviews[0].rating).to.equal(5);
    });
  });
});
