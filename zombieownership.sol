pragma solidity >=0.5.0 <0.6.0;
import "./zombieattack.sol";
import  "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

    function balanceOf(address _owner) external view returns (uint256) {
        
    } //end function balanceOf()

    function ownerOf(uint256 _tokenId) external view returns (address) {
        
    } //end function ownerOf()

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        
    } //end function transferFrom()

    function approve(address _approved, uint256 _tokenId) external payable {

    } //end function approve()
} //end contract ZombieOwnership{}