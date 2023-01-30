pragma solidity ^0.8.0;

contract RoyaltyContract {

    //structure to store the asset details
    struct Asset {
    address creator;
    uint8 royaltyPercentage;
    uint usageCount;
    }
//mapping to store the registered assets and their royalty terms
mapping (bytes32 => Asset) public assets;


//event to notify about the registered assets
event AssetRegistered(address indexed creator, bytes32 indexed assetId);

//event to notify about the royalties distribution
event RoyaltyDistributed(address indexed creator, uint256 royalties);

//function to register an asset
function registerAsset(bytes32 assetId, uint8 royaltyPercentage) public {
    require(msg.sender != address(0), "Only registered creators can register assets");
    require(assets[assetId].royaltyPercentage == 0, "Asset already registered");
    assets[assetId] = Asset(msg.sender, royaltyPercentage,0);
    emit AssetRegistered(msg.sender, assetId);
}

//function to track the usage of the asset
function trackAssetUsage(bytes32 assetId) public {
    require(assets[assetId].royaltyPercentage > 0, "Asset not registered");
    assets[assetId].usageCount++;
}

//function to distribute royalties
function distributeRoyalties() public {
    for (uint i = 0; i < assets.length; i++) {
        Asset memory asset = assets[i];
        if (asset.royaltyPercentage > 0 && asset.usageCount > 0) {
            uint royalties = (asset.usageCount * asset.royaltyPercentage) / 100;
            asset.creator.transfer(royalties);
            emit RoyaltyDistributed(asset.creator, royalties);
            asset.usageCount = 0;
        }
    }
}
}

