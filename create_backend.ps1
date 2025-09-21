# Create backend scaffold for Vsmart (PowerShell script)
# Save as create_backend.ps1 and run from your project root.
# Usage: .\create_backend.ps1

Set-StrictMode -Version Latest

$root = Join-Path (Get-Location) "backend"
Write-Host "Creating backend folder at $root"
New-Item -ItemType Directory -Force -Path $root | Out-Null

function writeFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $content | Out-File -FilePath $path -Encoding UTF8 -Force
  Write-Host "Wrote $path"
}

# package.json
writeFile "$root\package.json" @'
{
  "name": "vsmart-backend",
  "version": "1.0.0",
  "main": "dist/index.js",
  "license": "MIT",
  "scripts": {
    "dev": "ts-node-dev --respawn --transpile-only src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev --name init --preview-feature",
    "seed": "ts-node prisma/seed.ts"
  },
  "dependencies": {
    "@prisma/client": "^5.10.0",
    "bcrypt": "^5.1.0",
    "body-parser": "^1.20.2",
    "cors": "^2.8.5",
    "dotenv": "^16.0.3",
    "ethers": "^6.9.0",
    "express": "^4.18.2",
    "express-fileupload": "^1.4.0",
    "formidable": "^2.1.4",
    "jsonwebtoken": "^9.0.0",
    "multer": "^1.4.5-lts.1",
    "node-fetch": "^3.4.1",
    "web3.storage": "^5.0.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/jsonwebtoken": "^9.0.2",
    "@types/node": "^20.5.6",
    "prisma": "^5.10.0",
    "ts-node": "^10.9.1",
    "ts-node-dev": "^2.0.0",
    "typescript": "^5.4.2"
  }
}
'@

# tsconfig.json
writeFile "$root\tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "rootDir": "src",
    "outDir": "dist",
    "strict": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "skipLibCheck": true
  }
}
'@

# .env.example
writeFile "$root\.env.example" @'
# Basic
PORT=4000
JWT_SECRET=replace_with_a_strong_secret
NODE_ENV=development

# Database (used by docker-compose)
DATABASE_URL=postgresql://postgres:postgres@db:5432/vsmart?schema=public

# Web3 / IPFS
WEB3_STORAGE_TOKEN=

# Blockchain (optional)
MUMBAI_RPC_URL=
PRIVATE_KEY=

# AI service URL (optional). If empty, backend uses local heuristic (aiClient mock).
AI_SERVICE_URL=http://ai-service:8000/verify-image

# Mock settings
LOCAL_MOCK_MODE=true
'@

# docker-compose.yml
writeFile "$root\docker-compose.yml" @'
version: "3.8"
services:
  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: vsmart
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  backend:
    build: .
    depends_on:
      - db
    volumes:
      - ./:/usr/src/app
      - /usr/src/app/node_modules
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/vsmart?schema=public
      - PORT=4000
      - JWT_SECRET=devsecret
      - LOCAL_MOCK_MODE=true
    working_dir: /usr/src/app
    command: sh -c "npm install && npx prisma generate && npx prisma migrate deploy || true && npm run dev"
    ports:
      - "4000:4000"

volumes:
  pgdata:
'@

# prisma schema
writeFile "$root\prisma\schema.prisma" @'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum Role {
  NGO
  ADMIN
  COMPANY
}

enum ProjectStatus {
  DRAFT
  SUBMITTED
  UNDER_REVIEW
  SITE_VISIT_REQUIRED
  VERIFIED
  APPROVED
  CREDITS_ISSUED
  MONITORING_REQUIRED
  REJECTED
}

model User {
  id         String   @id @default(cuid())
  name       String
  email      String   @unique
  password   String
  role       Role
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
  pushToken  String?
  wallet     String?
  credits    Float    @default(0)
  projects   Project[] @relation("ownerProjects")
}

model Project {
  id          String       @id @default(cuid())
  title       String
  description String?
  area        Float?
  species     String?
  saplings    Int?
  lat         Float?
  lng         Float?
  language    String?
  status      ProjectStatus @default(DRAFT)
  aiConfidence Float?
  aiLabel     String?
  ownerId     String
  owner       User @relation(fields: [ownerId], references: [id], name: "ownerProjects")
  uploads     Upload[]
  verifications Verification[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  tokenId     String?
  cid         String?
}

model Upload {
  id         String   @id @default(cuid())
  projectId  String
  project    Project  @relation(fields: [projectId], references: [id])
  filename   String
  cid        String
  fileType   String
  createdAt  DateTime @default(now())
}

model Verification {
  id         String   @id @default(cuid())
  projectId  String
  project    Project  @relation(fields: [projectId], references: [id])
  label      String
  confidence Float
  meta       String?
  createdAt  DateTime @default(now())
}

model AuditLog {
  id         String   @id @default(cuid())
  userId     String?
  user       User?    @relation(fields: [userId], references: [id])
  projectId  String?
  project    Project? @relation(fields: [projectId], references: [id])
  action     String
  notes      String?
  txHash     String?
  createdAt  DateTime @default(now())
}

model Transaction {
  id          String  @id @default(cuid())
  companyId   String
  company     User    @relation(fields: [companyId], references: [id])
  projectId   String?
  project     Project? @relation(fields: [projectId], references: [id])
  amount      Float
  status      String
  invoiceUrl  String?
  txHash      String?
  createdAt   DateTime @default(now())
}

model AnalyticsEvent {
  id        String   @id @default(cuid())
  eventName String
  payload   Json?
  createdAt DateTime @default(now())
}
'@

# prisma seed.ts
writeFile "$root\prisma\seed.ts" @'
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

async function main() {
  console.log("Seeding demo users...");
  const admin = await prisma.user.upsert({
    where: { email: "admin@test.com" },
    update: {},
    create: {
      name: "Admin Demo",
      email: "admin@test.com",
      password: "password123",
      role: "ADMIN"
    }
  });

  const ngo = await prisma.user.upsert({
    where: { email: "ngo@test.com" },
    update: {},
    create: {
      name: "NGO Demo",
      email: "ngo@test.com",
      password: "password123",
      role: "NGO"
    }
  });

  const company = await prisma.user.upsert({
    where: { email: "company@test.com" },
    update: {},
    create: {
      name: "Company Demo",
      email: "company@test.com",
      password: "password123",
      role: "COMPANY",
      credits: 0
    }
  });

  console.log("Seeding sample projects...");
  const p1 = await prisma.project.upsert({
    where: { title: "Mangrove Site Alpha" },
    update: {},
    create: {
      title: "Mangrove Site Alpha",
      description: "Initial demo project pending approval",
      area: 0.5,
      species: "Rhizophora",
      saplings: 800,
      lat: 9.0,
      lng: 78.0,
      language: "en",
      ownerId: ngo.id,
      status: "SUBMITTED"
    }
  });

  const p2 = await prisma.project.upsert({
    where: { title: "Mangrove Site Beta" },
    update: {},
    create: {
      title: "Mangrove Site Beta",
      description: "Approved demo project with sample CID",
      area: 1.2,
      species: "Avicennia",
      saplings: 2000,
      lat: 9.2,
      lng: 78.1,
      language: "en",
      ownerId: ngo.id,
      status: "APPROVED",
      cid: "mock:sample-cid",
      tokenId: "1234"
    }
  });

  console.log({ admin, ngo, company, p1, p2 });
}

main().catch(e => {
  console.error(e);
  process.exit(1);
}).finally(async () => {
  await prisma.$disconnect();
});
'@

# src files
writeFile "$root\src\prismaClient.ts" @'
import { PrismaClient } from "@prisma/client";
export const prisma = new PrismaClient();
'@

writeFile "$root\src\types.ts" @'
export type Role = "NGO" | "ADMIN" | "COMPANY";
'@

writeFile "$root\src\utils\helpers.ts" @'
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

export const hash = (plain: string) => bcrypt.hashSync(plain, 10);
export const compare = (plain: string, hashed: string) => bcrypt.compareSync(plain, hashed);

export const signJwt = (payload: object) => {
  const secret = process.env.JWT_SECRET || "devsecret";
  return jwt.sign(payload, secret, { expiresIn: "7d" });
};

export const verifyJwt = (token: string) => {
  const secret = process.env.JWT_SECRET || "devsecret";
  return jwt.verify(token, secret);
};
'@

writeFile "$root\src\middleware\auth.ts" @'
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

declare global { namespace Express { interface Request { user?: any } } }

const JWT_SECRET = process.env.JWT_SECRET || "devsecret";

export function authRequired(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header) return res.status(401).json({ error: "Missing auth header" });
  const token = header.split(" ")[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET) as any;
    req.user = payload;
    return next();
  } catch (err) {
    return res.status(401).json({ error: "Invalid token" });
  }
}
'@

writeFile "$root\src\middleware\roles.ts" @'
import { Request, Response, NextFunction } from "express";

export function requireRole(role: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) return res.status(401).json({ error: "missing user" });
    if (req.user.role !== role && req.user.role !== "ADMIN") return res.status(403).json({ error: "forbidden" });
    next();
  };
}
'@

writeFile "$root\src\services\storage.ts" @'
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
'@

writeFile "$root\src\services\aiClient.ts" @'
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
'@

writeFile "$root\src\services\blockchain.ts" @'
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
'@

writeFile "$root\src\routes\auth.ts" @'
import express from "express";
import { prisma } from "../prismaClient";
import { hash, compare, signJwt } from "../utils/helpers";
const router = express.Router();

router.post("/register", async (req, res) => {
  const { name, email, password, role } = req.body;
  if (!name || !email || !password || !role) return res.status(400).json({ error: "missing fields" });
  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) return res.status(400).json({ error: "email exists" });
  const pw = process.env.NODE_ENV === "development" ? password : hash(password);
  const user = await prisma.user.create({
    data: { name, email, password: pw, role }
  });
  const token = signJwt({ id: user.id, email: user.email, role: user.role });
  res.json({ user: { id: user.id, name: user.name, email: user.email, role: user.role }, token });
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: "missing fields" });
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) return res.status(401).json({ error: "invalid credentials" });

  const isDev = process.env.NODE_ENV === "development" || process.env.LOCAL_MOCK_MODE === "true";
  const ok = isDev ? password === user.password : compare(password, user.password);
  if (!ok) return res.status(401).json({ error: "invalid credentials" });

  const token = signJwt({ id: user.id, email: user.email, role: user.role });
  res.json({ token, user: { id: user.id, name: user.name, email: user.email, role: user.role } });
});

export default router;
'@

writeFile "$root\src\routes\projects.ts" @'
import express from "express";
import multer from "multer";
import { prisma } from "../prismaClient";
import { authRequired } from "../middleware/auth";
import { requireRole } from "../middleware/roles";
import { saveFileAndGetCid } from "../services/storage";
import { verifyImageMock } from "../services/aiClient";
const router = express.Router();

const upload = multer({ storage: multer.memoryStorage() });

router.post("/", authRequired, requireRole("NGO"), async (req, res) => {
  const { title, description, area, species, saplings, lat, lng, language } = req.body;
  const project = await prisma.project.create({
    data: {
      title,
      description,
      area: area ? parseFloat(area) : undefined,
      species,
      saplings: saplings ? parseInt(saplings) : undefined,
      lat: lat ? parseFloat(lat) : undefined,
      lng: lng ? parseFloat(lng) : undefined,
      language,
      ownerId: req.user.id,
      status: "DRAFT"
    }
  });
  res.json({ project });
});

router.post("/:id/upload", authRequired, requireRole("NGO"), upload.single("file"), async (req, res) => {
  const file = req.file;
  const id = req.params.id;
  if (!file) return res.status(400).json({ error: "missing file" });

  const cid = await saveFileAndGetCid(file.buffer, `${Date.now()}_${file.originalname}`, file.mimetype);
  const dbu = await prisma.upload.create({
    data: {
      projectId: id,
      filename: file.originalname,
      cid,
      fileType: file.mimetype
    }
  });
  res.json({ upload: dbu, cid });
});

router.post("/:id/submit", authRequired, requireRole("NGO"), async (req, res) => {
  const id = req.params.id;
  const project = await prisma.project.findUnique({ where: { id }, include: { uploads: true } });
  if (!project) return res.status(404).json({ error: "project not found" });

  await prisma.project.update({ where: { id }, data: { status: "SUBMITTED" } });

  if (project.uploads && project.uploads.length > 0) {
    const verification = await verifyImageMock(Buffer.from(""), project.uploads[0].filename);
    await prisma.verification.create({
      data: { projectId: id, label: verification.label, confidence: verification.confidence, meta: JSON.stringify(verification) }
    });
    await prisma.project.update({ where: { id }, data: { aiLabel: verification.label, aiConfidence: verification.confidence } });
  }

  await prisma.auditLog.create({ data: { userId: req.user.id, projectId: id, action: "SUBMITTED", notes: "Submitted by NGO" } });

  console.log("Notify admin: new submission", id);

  res.json({ ok: true });
});

router.get("/", authRequired, async (req, res) => {
  const projects = await prisma.project.findMany({ include: { uploads: true }, orderBy: { createdAt: "desc" } });
  res.json({ projects });
});

router.get("/:id", authRequired, async (req, res) => {
  const id = req.params.id;
  const project = await prisma.project.findUnique({ where: { id }, include: { uploads: true, verifications: true } });
  if (!project) return res.status(404).json({ error: "not found" });
  res.json({ project });
});

export default router;
'@

writeFile "$root\src\routes\admin.ts" @'
import express from "express";
import { authRequired } from "../middleware/auth";
import { requireRole } from "../middleware/roles";
import { prisma } from "../prismaClient";
import { mintCertificateMock, mintCreditsMock } from "../services/blockchain";

const router = express.Router();

router.get("/projects/pending", authRequired, requireRole("ADMIN"), async (req, res) => {
  const pending = await prisma.project.findMany({ where: { status: "SUBMITTED" }, include: { owner: true, uploads: true } });
  res.json({ pending });
});

router.post("/projects/:id/status", authRequired, requireRole("ADMIN"), async (req, res) => {
  const { status, notes } = req.body;
  const id = req.params.id;
  const project = await prisma.project.update({ where: { id }, data: { status } });

  await prisma.auditLog.create({ data: { userId: req.user.id, projectId: id, action: `STATUS:${status}`, notes } });

  if (status === "APPROVED") {
    const { txHash, tokenId } = await mintCertificateMock(project.id, project.cid || "mock:metadata");
    await prisma.project.update({ where: { id }, data: { tokenId, cid: project.cid || "mock:metadata" } });
    await prisma.auditLog.create({ data: { userId: req.user.id, projectId: id, action: "MINTED_CERTIFICATE", txHash, notes: `minted ${tokenId}` }});
  }

  console.log("Notify NGO", project.ownerId, status);

  res.json({ ok: true, project });
});

router.get("/dashboard/stats", authRequired, requireRole("ADMIN"), async (req, res) => {
  const totalProjects = await prisma.project.count();
  const approved = await prisma.project.count({ where: { status: "APPROVED" }});
  const avgConfidence = await prisma.project.aggregate({ _avg: { aiConfidence: true }});
  res.json({ totalProjects, approved, avgConfidence: avgConfidence._avg.aiConfidence || 0 });
});

export default router;
'@

writeFile "$root\src\routes\cart.ts" @'
import express from "express";
import { authRequired } from "../middleware/auth";
import { prisma } from "../prismaClient";
const router = express.Router();

router.post("/checkout", authRequired, async (req, res) => {
  const { items } = req.body;
  if (!items || !Array.isArray(items) || items.length === 0) return res.status(400).json({ error: "no items" });

  const txs: any[] = [];
  for (const it of items) {
    const project = await prisma.project.findUnique({ where: { id: it.projectId }});
    if (!project) continue;
    const amount = parseFloat(String(it.amount || 0));
    const transaction = await prisma.transaction.create({
      data: {
        companyId: req.user.id,
        projectId: project.id,
        amount,
        status: "COMPLETED",
        invoiceUrl: `mock:invoice:${Date.now()}`
      }
    });
    await prisma.user.update({ where: { id: req.user.id }, data: { credits: { increment: amount } } as any });
    txs.push(transaction);
  }

  await prisma.analyticsEvent.create({ data: { eventName: "purchase_made", payload: { items, user: req.user.id } }});
  res.json({ success: true, transactions: txs });
});

export default router;
'@

writeFile "$root\src\app.ts" @'
import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import authRoutes from "./routes/auth";
import projectRoutes from "./routes/projects";
import adminRoutes from "./routes/admin";
import cartRoutes from "./routes/cart";
import dotenv from "dotenv";
dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => res.json({ ok: true, name: "vsmart-backend" }));

app.use("/auth", authRoutes);
app.use("/projects", projectRoutes);
app.use("/admin", adminRoutes);
app.use("/cart", cartRoutes);

import path from "path";
app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

export default app;
'@

writeFile "$root\src\index.ts" @'
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
'@

Write-Host "All files created. Now run the following commands (one by one):"
Write-Host ""
Write-Host "cd backend"
Write-Host "npm install"
Write-Host "npx prisma generate"
Write-Host "npx prisma migrate dev --name init  (if it prompts to create a migration, accept)"
Write-Host "npm run seed"
Write-Host "docker-compose up --build"
Write-Host ""
Write-Host "If you don't want docker, run: npm run dev  (after migrations + seed)"
