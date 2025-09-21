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
