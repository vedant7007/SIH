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
