// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Blockfund {
    struct Pitch {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] investors;
        uint256[] investments;
    }

    mapping(uint256 => Pitch) public Pitches;

    uint256 public numberOfPitches = 0;

    function createPitch(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Pitch storage pitch = Pitches[numberOfPitches];

        require(pitch.deadline < block.timestamp, "The deadline should be a date in the future.");

        pitch.owner = _owner;
        pitch.title = _title;
        pitch.description = _description;
        pitch.target = _target;
        pitch.deadline = _deadline;
        pitch.amountCollected = 0;
        pitch.image = _image;

        numberOfPitches++;

        return numberOfPitches - 1;
    }

    function donateToPitch(uint256 _id) public payable {
        uint256 amount = msg.value;

        Pitch storage pitch = Pitches[_id];

        pitch.investors.push(msg.sender);
        pitch.investments.push(amount);

        (bool sent,) = payable(pitch.owner).call{value: amount}("");

        if(sent) {
            pitch.amountCollected = pitch.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (Pitches[_id].investors, Pitches[_id].investments);
    }

    function getPitchs() public view returns (Pitch[] memory) {
        Pitch[] memory allPitchs = new Pitch[](numberOfPitches);

        for(uint i = 0; i < numberOfPitches; i++) {
            Pitch storage item = Pitches[i];

            allPitchs[i] = item;
        }

        return allPitchs;
    }
}