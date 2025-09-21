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
