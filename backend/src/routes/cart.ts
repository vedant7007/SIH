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
