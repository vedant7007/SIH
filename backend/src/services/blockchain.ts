import dotenv from "dotenv";
import { ethers } from "ethers";
dotenv.config();

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

export async function mintCertificateMock(projectId: string, metadataUri: string) {
  if (MUMBAI_RPC_URL && PRIVATE_KEY) {
    const provider = new ethers.JsonRpcProvider(MUMBAI_RPC_URL);
    const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
    return { txHash: "0xsimulated_real_net_tx_hash", tokenId: "real_net_tokenid" };
  }
  return { txHash: `mock_tx_${projectId}_${Date.now()}`, tokenId: `${Math.floor(Math.random() * 100000)}` };
}

export async function mintCreditsMock(projectId: string, recipientAddress: string, amount: number) {
  if (MUMBAI_RPC_URL && PRIVATE_KEY) {
    return { txHash: "0xsimulated_mumbai_mint" };
  }
  return { txHash: `mock_mint_${projectId}_${Date.now()}` };
}
