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
