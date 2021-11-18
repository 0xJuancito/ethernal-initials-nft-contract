// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract EthernalInitials is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;

  mapping(uint256 => string) public tokenBackgrounds;

  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style> .base { fill: white; font-family: serif; font-size: 160px; font-weight:800}</style>";
  string midSvg = "<rect fill='url(#pattern)' height='100%' width='100%'/><text x='50%' y='54%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string endSvg = "</text></svg>";

  mapping(string => string) private backgroundPatterns;
  string[] alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  string[] numbersList = ["0","1","2","3","4","5","6","7","8","9"];
  event NewInitialsNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("Ethernal Initials", "AAZZ") {
    backgroundPatterns['Ether'] = "<defs><pattern id='pattern' width='62' height='62' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(186, 170, 247)'/><path d='M0 0L20 0L20 20L0 20L0 0zM3.9 3.9L6 14L16.1 16.1L14 6zM20 20L40 20L40 40L20 40L20 20zM23.9 23.9L26 34L36.1 36.1L34 26z' fill='rgb(255, 184, 243)'/><path d='M26 6L36.1 3.9L34 14L23.3 16.7zM6 26L16.7 23.3L14 34L3.9 36.1z' fill='rgb(255, 219, 245)'/></pattern></defs>";

    backgroundPatterns['Gold'] = "<defs><pattern id='pattern' width='28' height='28' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform=''><rect width='100%' height='100%' fill='rgb(214, 164, 2)'/><path d='M8.2 8.2a 11.8 11.8 0 0 1 23.6 0a 11.8 11.8 0 0 1 0 23.6a 11.8 11.8 0 0 1-23.6 0a 11.8 11.8 0 0 1 0-23.6M10 17a 3 3 0 0 0 0 6a 7 7 0 0 1 7 7a 3 3 0 0 0 6 0a 7-7 0 0 1 7-7a 3 3 0 0 0 0-6a-7-7 0 0 1-7-7a 3 3 0 0 0-6 0a-7 7 0 0 1-7 7z' fill='rgb(233, 179, 2)'/><path d='M10 10a 10 10 0 0 1 20 0a 10 10 0 0 1 0 20a 10 10 0 0 1-20 0a 10 10 0 0 1 0-20M10 17a 3 3 0 0 0 0 6a 7 7 0 0 1 7 7a 3 3 0 0 0 6 0a 7-7 0 0 1 7-7a 3 3 0 0 0 0-6a-7-7 0 0 1-7-7a 3 3 0 0 0-6 0a-7 7 0 0 1-7 7z' fill='rgb(252, 194, 3)'/></pattern></defs>";
  
    backgroundPatterns['Chocolate'] = "<defs><pattern id='pattern' width='50' height='50' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform=''><rect width='100%' height='100%' fill='rgb(132, 86, 60)'/><path d='M0 40h-10v-60h60L40 0L34 6h-28v28z' fill='rgb(67, 26, 26)'/><path d='M40 0v10h60v60L0 40L6 34h28v-28z' fill='rgb(97, 68, 46)'/><path d='M40 0v10h60v60L0 40L0 40h40v-40z' fill='rgb(67, 26, 26)'/><path d='M0 40h-10v-60h60L40 0L40 0h-40v40z' fill='rgb(97, 68, 46)'/></pattern></defs><rect height='100%' width='100%' fill='url(#pattern)' />";
    backgroundPatterns['Gifts'] = "<defs><pattern id='pattern' width='99' height='99' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(28, 126, 214)'/><circle cx='0' cy='20' r='2' fill='rgb(252, 196, 25)'/><circle cx='40' cy='20' r='2' fill='rgb(252, 196, 25)'/><path d='m 18 16 h4 v8 h-4z' fill='rgb(24, 100, 171)'/></pattern></defs>";
  
    backgroundPatterns['Radiation'] = "<defs><pattern id='pattern' width='33.25' height='57' viewBox='0 0 35 60' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(204, 0, 34)'/><path d='M42.43 35.5L42.43 44.5L26.85 35.5L34.64 31L34.64 49L26.85 44.5L34.64 40z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M25.11 45.5L25.11 54.5L9.53 45.5L17.32 41L17.32 59L9.53 54.5L17.32 50z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M7.79 35.5L7.79 44.5L-7.79 35.5L0 31L0 49L-7.79 44.5L0 40z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M7.79 15.5L7.79 24.5L-7.79 15.5L0 11L0 29L-7.79 24.5L0 20z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M25.11 5.5L25.11 14.5L9.53 5.5L17.32 1L17.32 19L9.53 14.5L17.32 10z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M42.43 15.5L42.43 24.5L26.85 15.5L34.64 11L34.64 29L26.85 24.5L34.64 20z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/><path d='M34.64 48L41.57 44L27.71 36L27.71 44L41.57 36L34.64 32L34.64 40z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M17.32 58L24.25 54L10.39 46L10.39 54L24.25 46L17.32 42L17.32 50z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M0 48L6.93 44L-6.93 36L-6.93 44L6.93 36L0 32L0 40z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M0 28L6.93 24L-6.93 16L-6.93 24L6.93 16L0 12L0 20z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M17.32 18L24.25 14L10.39 6L10.39 14L24.25 6L17.32 2L17.32 10z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M34.64 28L41.57 24L27.71 16L27.71 24L41.57 16L34.64 12L34.64 20z' stroke-linejoin='miter' fill='rgb(255, 255, 0)'/><path d='M22.52 27L22.52 33L12.12 27L17.32 24L17.32 36L12.12 33L17.32 30z' stroke-linejoin='miter' fill='rgb(17, 17, 0)'/></pattern></defs>";
    backgroundPatterns['Scribble'] = "<defs><pattern id='pattern' width='29' height='29' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(28, 126, 214)'/><path d='M20 16a 20 20 0 0 1 40 0h4a 4 4 0 0 1-8 0a 16 16 0 0 0-32 0a 4 4 0 0 1-8 0a 16 16 0 0 0-32 0h-4a 20 20 0 0 1 40 0z' fill='rgb(252, 196, 25)'/><path d='M0 28a 20 20 0 0 1 40 0h4a 4 4 0 0 1-8 0a 16 16 0 0 0-32 0a 4 4 0 0 1-8 0z' fill='rgb(24, 100, 171)'/><path d='M20 56a 20 20 0 0 1 40 0h4a 4 4 0 0 1-8 0a 16 16 0 0 0-32 0a 4 4 0 0 1-8 0a 16 16 0 0 0-32 0h-4a 20 20 0 0 1 40 0z' fill='rgb(252, 196, 25)'/></pattern></defs>";
    backgroundPatterns['Stars'] = "<defs><pattern id='pattern' width='40.7' height='47' viewBox='0 0 69.2820323027551 80' patternUnits='userSpaceOnUse' patternTransform='rotate(45)'><rect width='100%' height='100%' fill='rgb(127, 5, 88)'/><path d='M86.6 70L69.28 80L51.96 70L51.96 50L69.28 40L86.6 50L86.6 70 86.6 50L69.28 40L51.96 50L51.96 70L69.28 80L86.6 70L86.6 50z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M51.96 90L34.64 100L17.32 90L17.32 70L34.64 60L51.96 70L51.96 90 51.96 70L34.64 60L17.32 70L17.32 90L34.64 100L51.96 90L51.96 70z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M17.32 70L0 80L-17.32 70L-17.32 50L0 40L17.32 50L17.32 70 17.32 50L0 40L-17.32 50L-17.32 70L0 80L17.32 70L17.32 50z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M17.32 30L0 40L-17.32 30L-17.32 10L0 0L17.32 10L17.32 30 17.32 10L0 0L-17.32 10L-17.32 30L0 40L17.32 30L17.32 10z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M51.96 10L34.64 20L17.32 10L17.32-10L34.64-20L51.96-10L51.96 10 51.96-10L34.64-20L17.32-10L17.32 10L34.64 20L51.96 10L51.96-10z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M86.6 30L69.28 40L51.96 30L51.96 10L69.28 0L86.6 10L86.6 30 86.6 10L69.28 0L51.96 10L51.96 30L69.28 40L86.6 30L86.6 10z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/><path d='M40.7 43.5L40.7 50.5L34.64 47L28.58 50.5L28.58 43.5L22.52 40L28.58 36.5L28.58 29.5L34.64 33L40.7 29.5L40.7 36.5L46.77 40L40.7 43.5 38.14 33.94L34.64 43.88L31.14 33.94L38 41.94L27.64 40L38 38.06L31.14 46.06L34.64 36.12L38.14 46.06L31.28 38.06L41.64 40L31.28 41.94L38.14 33.94z' stroke-linejoin='miter' fill='rgb(253, 217, 176)'/></pattern></defs>";
  
    backgroundPatterns['Checkers'] = "<defs><pattern id='pattern' width='20' height='20' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform=''><rect width='100%' height='100%' fill='rgb(36, 32, 36)'/><path d='M0 20L20 40L40 20L20 0L0 20z' fill='rgb(191, 0, 0)'/><path d='M0 20L20 20L40 20L20 20z' fill='rgb(79, 209, 197)'/></pattern></defs>";
    backgroundPatterns['Wool'] = "<defs><pattern id='pattern' width='55' height='55' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform='rotate(45)'><rect width='100%' height='100%' fill='rgb(4, 4, 139)'/><path d='M-4 20v20h8v-20zM36 20v20h8v-20z' fill='rgb(31, 63, 171)'/><path d='M-10 26.5 h60 v7 h-60z' fill='rgb(97, 87, 189)'/><path d='M16 0v40h8v-40z' fill='rgb(31, 63, 171)'/><path d='M-10 6.5h60v7h-60z' fill='rgb(97, 87, 189)'/><path d='M-4 0v20h8v-20zM36 0v20h8v-20z' fill='rgb(31, 63, 171)'/></pattern></defs>";
    backgroundPatterns['Honey'] = "<defs><pattern id='pattern' width='46.19' height='40' viewBox='0 0 34.64101615137755 30' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(58, 54, 55)'/><path d='M-20-20h200v200h-200M33.77 25.5L25.98 21L18.19 25.5L18.19 34.5L25.98 39L33.77 34.5zM16.45 25.5L8.66 21L0.87 25.5L0.87 34.5L8.66 39L16.45 34.5zM7.79 10.5L0 6L-7.79 10.5L-7.79 19.5L0 24L7.79 19.5zM16.45-4.5L8.66-9L0.87-4.5L0.87 4.5L8.66 9L16.45 4.5zM33.77-4.5L25.98-9L18.19-4.5L18.19 4.5L25.98 9L33.77 4.5zM42.43 10.5L34.64 6L26.85 10.5L26.85 19.5L34.64 24L42.43 19.5zM25.11 10.5L17.32 6L9.53 10.5L9.53 19.5L17.32 24L25.11 19.5z' fill='rgb(35, 33, 44)'/><path d='M-20-20h200v200h-200M24.21 25.25L15.98 20.5L7.75 25.25L7.75 34.75L15.98 39.5L24.21 34.75zM6.89 25.25L-1.34 20.5L-9.57 25.25L-9.57 34.75L-1.34 39.5L6.89 34.75zM-1.77 10.25L-10 5.5L-18.23 10.25L-18.23 19.75L-10 24.5L-1.77 19.75zM6.89-4.75L-1.34-9.5L-9.57-4.75L-9.57 4.75L-1.34 9.5L6.89 4.75zM24.21-4.75L15.98-9.5L7.75-4.75L7.75 4.75L15.98 9.5L24.21 4.75zM32.87 10.25L24.64 5.5L16.41 10.25L16.41 19.75L24.64 24.5L32.87 19.75zM41.53 25.25L33.3 20.5L25.07 25.25L25.07 34.75L33.3 39.5L41.53 34.75zM15.55 40.25L7.32 35.5L-0.91 40.25L-0.91 49.75L7.32 54.5L15.55 49.75zM-10.43 25.25L-18.66 20.5L-26.89 25.25L-26.89 34.75L-18.66 39.5L-10.43 34.75zM-10.43-4.75L-18.66-9.5L-26.89-4.75L-26.89 4.75L-18.66 9.5L-10.43 4.75zM15.55-19.75L7.32-24.5L-0.91-19.75L-0.91-10.25L7.32-5.5L15.55-10.25zM41.53-4.75L33.3-9.5L25.07-4.75L25.07 4.75L33.3 9.5L41.53 4.75zM32.87 40.25L24.64 35.5L16.41 40.25L16.41 49.75L24.64 54.5L32.87 49.75zM-1.77 40.25L-10 35.5L-18.23 40.25L-18.23 49.75L-10 54.5L-1.77 49.75zM-19.09 10.25L-27.32 5.5L-35.55 10.25L-35.55 19.75L-27.32 24.5L-19.09 19.75zM-1.77-19.75L-10-24.5L-18.23-19.75L-18.23-10.25L-10-5.5L-1.77-10.25zM32.87-19.75L24.64-24.5L16.41-19.75L16.41-10.25L24.64-5.5L32.87-10.25zM50.19 10.25L41.96 5.5L33.73 10.25L33.73 19.75L41.96 24.5L50.19 19.75zM15.55 10.25L7.32 5.5L-0.91 10.25L-0.91 19.75L7.32 24.5L15.55 19.75z' fill='rgb(252, 214, 21)'/></pattern></defs>";
    backgroundPatterns['Atoms'] = "<defs><pattern id='pattern' width='25' height='25' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform=''><rect width='100%' height='100%' fill='rgb(46, 59, 110)'/><circle cx='20' cy='20' r='3' fill='rgb(251, 216, 118)'/><circle cx='30' cy='20' r='1.5' fill='rgb(214, 158, 46)'/><circle cx='23.09' cy='29.51' r='1.5' fill='rgb(214, 158, 46)'/><circle cx='11.91' cy='25.88' r='1.5' fill='rgb(214, 158, 46)'/><circle cx='11.91' cy='14.12' r='1.5' fill='rgb(214, 158, 46)'/><circle cx='23.09' cy='10.49' r='1.5' fill='rgb(214, 158, 46)'/><circle cx='30' cy='20' r='1.5' fill='rgb(214, 158, 46)'/></pattern></defs>";
    
    backgroundPatterns['Black'] = "<defs><pattern id='pattern' width='28' height='28' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform=''><rect width='100%' height='100%' fill='rgb(0, 0, 0)'/></pattern></defs>";
  }

  function contractURI() public pure returns (string memory) {
    string memory imageSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350' style='fill: white; font-family: serif; font-size: 160px; font-weight: 800'>  <defs><pattern id='ether' width='62' height='62' viewBox='0 0 40 40' patternUnits='userSpaceOnUse' patternTransform='rotate(135)'><rect width='100%' height='100%' fill='rgb(186, 170, 247)'/><path d='M0 0L20 0L20 20L0 20L0 0zM3.9 3.9L6 14L16.1 16.1L14 6zM20 20L40 20L40 40L20 40L20 20zM23.9 23.9L26 34L36.1 36.1L34 26z' fill='rgb(255, 184, 243)'/><path d='M26 6L36.1 3.9L34 14L23.3 16.7zM6 26L16.7 23.3L14 34L3.9 36.1z' fill='rgb(255, 219, 245)'/></pattern></defs><rect fill='url(#ether)' height='100%' width='100%'/><text x='50%' y='54%' dominant-baseline='middle' text-anchor='middle'>EI</text></svg>";

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "Ethernal Initials", "description": "An initials pair from AA to ZZ, and 00 to 99 that will live for eternity in this realm.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(imageSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalContractUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    return finalContractUri;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

    string memory background = tokenBackgrounds[tokenId];
    string memory first = pickFirstInitial(tokenId);
    string memory second = pickSecondInitial(tokenId);
    string memory name = string(abi.encodePacked(first, second));
    string memory backgroundPattern = backgroundPatterns[background];
    string memory finalSvg = string(abi.encodePacked(baseSvg, backgroundPattern, midSvg, name, endSvg));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    name,
                    '", "description": "',
                    name,
                    ' Loves ',
                    background,
                    '", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '", "attributes": [{"trait_type": "Background", "value": "',
                    background,
                    '"}]}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    return finalTokenUri;
  }

  function pickFirstInitial(uint256 tokenId) internal view returns (string memory) {
    return tokenId < 100
      ? numbersList[tokenId / numbersList.length]
      : alphabet[(tokenId - 100) / alphabet.length];
  }

  function pickSecondInitial(uint256 tokenId) internal view returns (string memory) {
    return tokenId < 100
      ? numbersList[tokenId % numbersList.length]
      : alphabet[(tokenId - 100) % alphabet.length];
  }

  function pickRandomBackground(uint256 tokenId) internal view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(block.number, block.timestamp, msg.sender, tokenId)));
    rand = rand % 100;
    // 1%
    if (rand == 0) {
      return 'Ether';
    }

    // 3%
    if (rand <= 3) {
      return 'Gold';
    }
    
    // 5%
    if (rand <= 8) {
      return 'Chocolate';
    }
    if (rand <= 13) {
      return 'Gifts';
    }

    // 7%
    if (rand <= 20) {
      return 'Radiation';
    }
    if (rand <= 27) {
      return 'Scribble';
    }
    if (rand <= 34) {
      return 'Stars';
    }

    // 10%
    if (rand <= 44) {
      return 'Checkers';
    }
    if (rand <= 54) {
      return 'Wool';
    }
    if (rand <= 64) {
      return 'Honey';
    }
    if (rand <= 74) {
      return 'Atoms';
    }

    // 25%
    return 'Black';   
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function mintNFT(uint256 tokenId) public {
    require(tokenId >= 0 && tokenId < 776, "Token ID invalid");

    string memory background = pickRandomBackground(tokenId);

    console.log(tokenId, background);

    _safeMint(msg.sender, tokenId);

    _tokenIds.increment();

    tokenBackgrounds[tokenId] = background;

    emit NewInitialsNFTMinted(msg.sender, tokenId);
  }

  function totalSupply() public view virtual returns (uint256) {
      return _tokenIds.current();
  }
}