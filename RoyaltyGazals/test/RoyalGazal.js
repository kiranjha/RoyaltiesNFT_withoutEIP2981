const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Contract Deploy", async () => {
    let contract, artist, addr1, addr2;

    beforeEach(async () => {
        [contract, addr1, addr2] = await ethers.getSigners();
        contract = await ethers.getContractFactory("RoyalGazal");
        artist = await contract.deploy();
        await artist.deployed();
        console.log("RoyalGazal contract address :- ", artist.address);
    });
    it("should be deployed", async () => {
        expect(artist.address).to.not.be.null;
    });
    it("should support the ERC721 and ERC2981 standards", async () => {
        const ERC721InterfaceId = "0x80ac58cd";
        const ERC2981InterfaceId = "0x2a55205a";
        let isERC721 = await artist.supportsInterface(ERC721InterfaceId);
        let isERC2981 = await artist.supportsInterface(ERC2981InterfaceId);
        expect(isERC721).to.equal(true);
        expect(isERC2981).to.equal(true);
    });
    it("should return the correct royalty info when specified and burned", async () => {
        await artist.mintNFT(addr1.address, "fakeTokenURI");

        await artist.mintNFTWithRoyalty(addr1.address, "fakeTokenURI", artist.address, 1000); //1000 basis points means 10% (10 * 100)
        const defaultRoyaltyInfo = await artist.royaltyInfo(1, 1000);
        const tokenRoyaltyInfo = await artist.royaltyInfo(2, 1000);
        const owner = await artist.owner();
        expect(defaultRoyaltyInfo[0]).to.equal(owner);
        expect(defaultRoyaltyInfo[1].toNumber()).to.equal(10);
        expect(tokenRoyaltyInfo[0]).to.equal(artist.address);
        expect(tokenRoyaltyInfo[1].toNumber()).to.equal(100);

    });
});
