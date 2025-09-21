import dotenv from "dotenv";
dotenv.config();
import app from "./app";
import { prisma } from "./prismaClient";

const PORT = process.env.PORT || 4000;

async function start() {
  app.listen(PORT, () => {
    console.log(`vsmart backend running on http://localhost:${PORT}`);
  });
  await prisma.$connect().catch(e => console.error("Prisma connect error", e));
}
start();
