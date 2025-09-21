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

  await prisma.project.create({
    data: {
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

  await prisma.project.create({
    data: {
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
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
