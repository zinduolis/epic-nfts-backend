// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFTbkp is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint nftsQuantityAllowed = 50;
    string[] firstWords = ["Afforest",  "Aftermath", "Becalm",  "Blithesome",  "Broadsheet",  "Buffoonish",  "Caprice",  "Capricious",  "Causerie",  "Chivalrous",  "Congratulatory",  "Dapper",  "Debonaire",  "Devil-May-Care",  "Emblazon"];
    string[] secondWords = ["Eudaemonia",  "Extremum",  "Exultant",  "Featherbrained",  "Felicity",  "Fiddle-Faddle",  "Gabble",  "Gallant",  "Gilt",  "Gleeful",  "Halcyon",  "Happy-Go-Lucky",  "Heyday",  "Hotheaded",  "Ism",  "Madcap",  "Majestic"];
    string[] thirdWords = ["Merry Andrew",  "Natty",  "Noble-Minded",  "Nuance",  "Phantasy",  "Pollyannaish",  "Prate",  "Sappy",  "Snappy",  "Spiffy",  "Stunner",  "Timberland",  "Timbre",  "Tittle-Tattle",  "Twaddle",  "Vividness",  "Wearisome",  "Whimsical",  "Whimsy",  "Zippy"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("I'm excited to get my NFT contract working!");
    }

    function concatRandomWords() public view returns (string memory, uint) {
        uint firstWordNr = uint(keccak256(abi.encodePacked(firstWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % firstWords.length - 1; 
        uint secondWordNr = uint(keccak256(abi.encodePacked(secondWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % secondWords.length - 1; 
        uint thirdWordNr = uint(keccak256(abi.encodePacked(thirdWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % thirdWords.length - 1;
        uint colorNumber = uint(keccak256(abi.encodePacked(firstWords[0], secondWords[0], thirdWords[0], block.timestamp))) % 1000000;
        console.log("Word numbers: %d %d %d", firstWordNr, secondWordNr, thirdWordNr); 
        console.log("Color number: ", colorNumber);
        string memory concatWords = string.concat(firstWords[firstWordNr], secondWords[secondWordNr], thirdWords[thirdWordNr]);
        console.log("Concatenated string is: %s", concatWords);
        // console.log("First Length: %s \n Second: %s \n Third: %s", firstWords.length, secondWords.length, thirdWords.length);
        return (concatWords, colorNumber);
    }

    function createImageString(string memory _randomWords, uint _colorNumber) public view returns (string memory) {
        string memory svg = string.concat("<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='#", Strings.toString(_colorNumber),"' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>", _randomWords,"</text></svg>");
        console.log("svg: %s", svg);
        string memory encodedSvg = Base64.encode(bytes(string(abi.encodePacked(svg))));
        // console.log ("encodedSvg: ", encodedSvg);
        string memory imageString = string.concat("data:application/json;base64,",encodedSvg);
        // console.log("imageString: ", imageString);
        return imageString;
    }

    function prepareEncodedJSON(string memory _randomWords, string memory _imageString) public pure returns (string memory) {
        string memory json = string.concat('{"name": "', _randomWords, '", "description" : "Funny collection of squares.", "image" : "', _imageString, '"}');
        // console.log("JSON: %s", json);
        string memory encodedJSON = Base64.encode(bytes(string(abi.encodePacked(json))));
        // console.log("encodedJSON: %s", encodedJSON);
        string memory jsonString = string.concat("data:application/json;base64,",encodedJSON);
        // console.log("jsonString: %s", jsonString);
        return jsonString;
    }

    function getTotalNFTsMintedSoFar() public view returns (uint) {
        uint totalNfts = _tokenIds.current();
        return totalNfts;
    }

    function makeAnEpicNFT() public {
        require(getTotalNFTsMintedSoFar() < nftsQuantityAllowed, "Just 50 NFTs can be minted on this contract");
        uint256 newItemId = _tokenIds.current();
        (string memory randomWords, uint randomColor) = concatRandomWords();
        string memory imageString = createImageString(randomWords, randomColor);
        string memory encodedJSON = prepareEncodedJSON(randomWords, imageString); 
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, encodedJSON);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function makeRandomNFTFromIPFS(string memory _ipfsLink) public {
        require(getTotalNFTsMintedSoFar() < nftsQuantityAllowed, "Just 50 NFTs can be minted on this contract");
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _ipfsLink);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}

