// SPDX-License_Identifier: UNLICENSED
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract DaPussNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721('DaPuss', 'PUSS'){
        maxSupply = 1000;
        totalSupply = 0;
        mintPrice = 0.1 ether;
    }

    function toggleIsMintEnabled() external onlyOwner{
        isMintEnabled= !isMintEnabled;
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner{
        require(maxSupply_ > 0, 'Max supply cannot be less than 0');
        require(maxSupply_ < 10000, 'Max supply cannot be more than 10000');
        require(maxSupply_ > totalSupply, 'Max supply cannot be more than the total supply');
        maxSupply = maxSupply_;
    }

    function setBaseTokenUrl(string calldata baseTokenUri_) external onlyOwner{
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_)public view override returns (string memory){
        require(_exists(tokenId_), 'Token does not exist!');
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_),".json"));
    }
    
    function withdraw() external onlyOwner{
        (bool success, ) = withdrawWallet.call{value: address(this).balance}('');
        require (success, 'Withdraw failed');
    }

    function mint(uint256 quantity_) public payable{
        require(isMintEnabled, 'Minting not enabled');
        require(mintedWallets[msg.sender] + quantity_ <= 10, 'Exceeds max mints per wallet');
        require(msg.value == mintPrice * quantity_, 'Wrong price supplied');
        require(maxSupply + quantity_ >= totalSupply, 'Sold out');

        for(uint256 i = 0; i < quantity_; i++){
            mintedWallets[msg.sender]++;
            totalSupply++;
            uint256 tokenId = totalSupply;
            _safeMint(msg.sender, tokenId);
        }
    }
}