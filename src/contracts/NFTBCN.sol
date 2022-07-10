//SPDX-License-Identifier: GPL-3.0

/* ***************************************************************************************************/                                     
/*                                                          dddddddd                                 */
/* KKKKKKKKK    KKKKKKK  iiii                               d::::::dlllllll                          */
/* K:::::::K    K:::::K i::::i                              d::::::dl:::::l                          */
/* K:::::::K    K:::::K  iiii                               d::::::dl:::::l                          */
/* K:::::::K   K::::::K                                     d:::::d l:::::l                          */
/* KK::::::K  K:::::KKKiiiiiiinnnn  nnnnnnnn        ddddddddd:::::d  l::::lyyyyyyy           yyyyyyy */
/*  K:::::K K:::::K   i:::::in:::nn::::::::nn    dd::::::::::::::d  l::::l y:::::y         y:::::y   */
/*   K::::::K:::::K     i::::in::::::::::::::nn  d::::::::::::::::d  l::::l  y:::::y       y:::::y   */
/*   K:::::::::::K      i::::inn:::::::::::::::nd:::::::ddddd:::::d  l::::l   y:::::y     y:::::y    */
/*   K:::::::::::K      i::::i  n:::::nnnn:::::nd::::::d    d:::::d  l::::l    y:::::y   y:::::y     */
/*   K::::::K:::::K     i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l     y:::::y y:::::y      */
/*   K:::::K K:::::K    i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l      y:::::y:::::y       */
/* KK::::::K  K:::::KKK i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l       y:::::::::y        */
/* K:::::::K   K::::::Ki::::::i n::::n    n::::nd::::::ddddd::::::ddl::::::l       y:::::::y         */
/* K:::::::K    K:::::Ki::::::i n::::n    n::::n d:::::::::::::::::dl::::::l        y:::::y          */
/* K:::::::K    K:::::Ki::::::i n::::n    n::::n  d:::::::::ddd::::dl::::::l       y:::::y           */
/* KKKKKKKKK    KKKKKKKiiiiiiii nnnnnn    nnnnnn   ddddddddd   dddddllllllll      y:::::y            */
/*                                                                              y:::::y              */
/*                                                                             y:::::y               */
/*                                                                           y:::::y                 */
/*                                                                          y:::::y                  */
/*                                                                          yyyyyyy                  */
/*****************************************************************************************************/
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./interfaces/IERC2981.sol";
contract KindlyNFT is ERC1155, IERC2981 {

    address public admin;

    uint256 public id;

    bool public paused;

    constructor(string memory _metadata) ERC1155(_metadata)   {
    admin = msg.sender;
    id = 1;
    paused = true;
}

function supportsInterface(bytes4 interfaceId) public view virtual override (ERC1155, IERC2981) returns (bool) {
    return (
    ERC1155.supportsInterface(interfaceId) 
    || interfaceId == type(IERC2981).interfaceId);
}

function royaltyInfo(uint256 tokenId, uint256 _salePrice) virtual override external view returns (address _receiver, uint256 _royaltyAmount) {
    require(tokenId < id, "Error: invalid token id");
    return (0xE77F7bd3FFF57c673f8805De68B62d8521B8C950, _salePrice * 5 / 100);
}

function mint(uint256 _amount) public payable {
    require(paused == false, "Error: public mint is paused");
    require(msg.value >= 0.04 ether, "Error: insufficient funds");
    id++;
    _mint(msg.sender, (id - 1), _amount, "");
}

function setAdmin(address _admin) virtual public onlyAdmin {
    require(admin != _admin, "Error: admin already setted");
    admin = _admin;
}

function setPaused(bool _paused) virtual public onlyAdmin {
    require(paused != _paused, "Error: public mint already paused");
    paused = _paused;
}

function owner() virtual public view returns (address) {
    return admin;
}

receive() external payable {
    //address of your deployed kindly particular contract
    address _kindly = 0xE77F7bd3FFF57c673f8805De68B62d8521B8C950;
    (bool success, ) = _kindly.call{value:msg.value}("");
    require(success, "Error: money not sended");
}

modifier onlyAdmin {
    require(msg.sender == admin, "Error: only admin can call this function");
    _;
}

}
