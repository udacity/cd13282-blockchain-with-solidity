const { expect } = require("chai");

describe("DecentralizedMarketplace", function () {
  let DecentralizedMarketplace;
  let marketplace;
  let owner;
  let seller;
  let buyer;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    DecentralizedMarketplace = await ethers.getContractFactory(
      "DecentralizedMarketplace"
    );
    [owner, seller, buyer, addr1, addr2, ...addrs] = await ethers.getSigners();

    // Deploy a new contract before each test.
    marketplace = await DecentralizedMarketplace.deploy();
  });

  describe("Listing and purchasing workflow", function () {
    it("Should allow users to list and purchase items", async function () {
      // Seller lists an item.
      const listingPrice = ethers.utils.parseEther("1.0"); // 1 ETH
      await marketplace.connect(seller).listItem("Test Item", listingPrice);

      // Buyer purchases the item.
      await marketplace.connect(buyer).purchaseItem(1, { value: listingPrice });

      // Check that the item is marked as not available after purchase.
      const item = await marketplace.getItem(1);
      expect(item.available).to.equal(false);

      // Verify the transfer was successful.
      expect(await marketplace.connect(seller).getBalance()).to.equal(
        listingPrice
      );
    });
  });

  describe("Review system", function () {
    it("Should allow users to leave reviews on items", async function () {
      // Preconditions: item is listed and purchased.
      const listingPrice = ethers.utils.parseEther("1.0"); // 1 ETH
      await marketplace.connect(seller).listItem("Test Item", listingPrice);
      await marketplace.connect(buyer).purchaseItem(1, { value: listingPrice });

      // Buyer leaves a review.
      await marketplace.connect(buyer).addReview(1, "Great product!", 5);

      // Fetch and verify the review.
      const reviews = await marketplace.getReviews(1);
      expect(reviews.length).to.equal(1);
      expect(reviews[0].rating).to.equal(5);
      expect(reviews[0].comment).to.equal("Great product!");
    });
  });

  // Additional tests can go here.
});
