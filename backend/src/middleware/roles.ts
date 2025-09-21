import { Request, Response, NextFunction } from "express";

export function requireRole(role: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) return res.status(401).json({ error: "missing user" });
    if (req.user.role !== role && req.user.role !== "ADMIN") return res.status(403).json({ error: "forbidden" });
    next();
  };
}
