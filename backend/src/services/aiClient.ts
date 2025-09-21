import fetch from "node-fetch";
import dotenv from "dotenv";
import { prisma } from "../prismaClient";
dotenv.config();

const AI_SERVICE_URL = process.env.AI_SERVICE_URL || "";

export async function verifyImageMock(fileBuffer: Buffer, filename: string) {
  if (AI_SERVICE_URL) {
    try {
      const resp = await fetch(AI_SERVICE_URL, {
        method: "POST",
        headers: { "Content-Type": "application/octet-stream" },
        body: fileBuffer
      });
      const json = await resp.json();
      return json;
    } catch (e) {
      console.warn("AI service call failed, falling back to local heuristic", e);
    }
  }

  const confidence = Math.min(0.95, Math.max(0.05, Math.random()));
  const label = confidence > 0.5 ? "vegetation" : "non-vegetation";
  return { label, confidence };
}
