// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    //TODO: update lists with random words.
    string[] firstWords = ["bla", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];
    string[] secondWords = ["eh", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];
    string[] thirdWords = ["cools", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD", "YOUR_WORD"];

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("I'm excited to get my NFT contract working!");
    }

    function concatRandomWords() public view returns (string memory) {
        uint firstWordNr = uint(keccak256(abi.encodePacked(firstWords[0], Strings.toString(_tokenIds.current())))) % 5; 
        uint secondWordNr = uint(keccak256(abi.encodePacked(secondWords[0], Strings.toString(_tokenIds.current())))) % 5; 
        uint thirdWordNr = uint(keccak256(abi.encodePacked(thirdWords[0], Strings.toString(_tokenIds.current())))) % 5;
        console.log("Word numbers: %d %d %d", firstWordNr, secondWordNr, thirdWordNr); 
        string memory concatWords = string.concat(firstWords[firstWordNr], secondWords[secondWordNr], thirdWords[thirdWordNr]);
        console.log("Concatenated string is: %s", concatWords);
        return concatWords;
    }

    function createImageString(string memory _threeWords) public view returns (string memory) {
        string memory svg = string.concat("<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>", _threeWords,"</text></svg>");
        console.log("svg: %s", svg);
        string memory encodedSvg = Base64.encode(bytes(string(abi.encodePacked(svg))));
        console.log ("encodedSvg: ", encodedSvg);
        string memory imageString = string.concat("data:application/json;base64,",encodedSvg);
        console.log("imageString: ", imageString);
        return imageString;
    }
//TODO: update
    // function pickRandomFirstWord() public {
    //     random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    //     string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
    // }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ==");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
    }
}

