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
