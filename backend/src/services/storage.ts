import fs from "fs";
import path from "path";
import { Web3Storage, File } from "web3.storage";
const uploadsDir = path.resolve(process.cwd(), "uploads");

if (!fs.existsSync(uploadsDir)) fs.mkdirSync(uploadsDir);

const token = process.env.WEB3_STORAGE_TOKEN;

export async function saveFileAndGetCid(fileBuffer: Buffer, filename: string, mimetype: string) {
  if (token) {
    try {
      const client = new Web3Storage({ token });
      const f = new File([fileBuffer], filename, { type: mimetype });
      const cid = await client.put([f]);
      return cid;
    } catch (e) {
      console.error("web3.storage upload failed:", e);
      // fallback to local mock
    }
  }
  // local mock: write file and return mock cid
  const dest = path.join(uploadsDir, filename);
  fs.writeFileSync(dest, fileBuffer);
  return `mock:${filename}`;
}
