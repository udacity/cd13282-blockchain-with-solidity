import React, { useState, useEffect } from "react";
import getWeb3 from "./getWeb3";
import contractAddress from "./contracts/contract-address.json";
import promVotingABI from "./contracts/PromVoting.json";

function App() {
  const address = contractAddress.PromVoting;
  const [web3, setWeb3] = useState(undefined);
  const [accounts, setAccounts] = useState([]);
  const [contract, setContract] = useState(undefined);

  useEffect(() => {
    const init = async () => {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const contract = new web3.eth.Contract(promVotingABI, promVotingAddress);
      setWeb3(web3);
      setAccounts(accounts);
      setContract(contract);
    };
    init();
  }, []);

  // Example function to cast a vote
  const vote = async (candidateName) => {
    await contract.methods.vote(candidateName).send({ from: accounts[0] });
  };

  // Add more functions as needed to interact with your contract

  return (
    <div className="App">
      {/* UI Components to interact with the contract */}
    </div>
  );
}

export default App;
