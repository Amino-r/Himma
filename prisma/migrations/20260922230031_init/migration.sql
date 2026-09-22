/*
  Warnings:

  - The primary key for the `Scholarship` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `applicationUrl` to the `Scholarship` table without a default value. This is not possible if the table is not empty.
  - Added the required column `coverageType` to the `Scholarship` table without a default value. This is not possible if the table is not empty.
  - Added the required column `opensAt` to the `Scholarship` table without a default value. This is not possible if the table is not empty.
  - Added the required column `providerId` to the `Scholarship` table without a default value. This is not possible if the table is not empty.
  - Added the required column `studyCountry` to the `Scholarship` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `id` on the `Scholarship` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `degreeLevel` on the `Scholarship` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('STUDENT', 'ADMIN');

-- CreateEnum
CREATE TYPE "HighestEducationLevel" AS ENUM ('DIPLOMA', 'BACHELOR', 'MASTER', 'PHD');

-- CreateEnum
CREATE TYPE "FieldOfStudy" AS ENUM ('COMPUTER_SCIENCE', 'MEDICINE', 'ENGINEERING', 'BUSINESS', 'LAW', 'PSYCHOLOGY', 'OTHER');

-- CreateEnum
CREATE TYPE "Type" AS ENUM ('UNIVERSITY', 'GOVERNMENT', 'NGO', 'FOUNDATION');

-- CreateEnum
CREATE TYPE "DegreeLevel" AS ENUM ('DIPLOMA', 'BACHELOR', 'MASTER', 'PHD');

-- CreateEnum
CREATE TYPE "CoverageType" AS ENUM ('FULL', 'PARTIAL');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('INTERESTED', 'IN_PROGRESS', 'SUBMITTED', 'ACCEPTED', 'REJECTED');

-- AlterTable
ALTER TABLE "Scholarship" DROP CONSTRAINT "Scholarship_pkey",
ADD COLUMN     "allowedNationalities" TEXT[],
ADD COLUMN     "applicationUrl" TEXT NOT NULL,
ADD COLUMN     "coveragePercent" INTEGER,
ADD COLUMN     "coverageType" "CoverageType" NOT NULL,
ADD COLUMN     "fields" TEXT[],
ADD COLUMN     "fundingDetails" JSONB,
ADD COLUMN     "languageRequirements" JSONB,
ADD COLUMN     "maxAge" INTEGER,
ADD COLUMN     "minGpa" DOUBLE PRECISION,
ADD COLUMN     "opensAt" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "otherRequirements" TEXT[],
ADD COLUMN     "providerId" UUID NOT NULL,
ADD COLUMN     "requiredDocuments" JSONB,
ADD COLUMN     "studyCountry" TEXT NOT NULL,
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL,
DROP COLUMN "degreeLevel",
ADD COLUMN     "degreeLevel" "DegreeLevel" NOT NULL,
ALTER COLUMN "acceptsExpiredDocuments" DROP DEFAULT,
ADD CONSTRAINT "Scholarship_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "highestEducationLevel" "HighestEducationLevel" NOT NULL,
    "fieldOfStudy" "FieldOfStudy",
    "nationality" TEXT,
    "gpa" DOUBLE PRECISION,
    "dateOfBirth" DATE,
    "graduationYear" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Provider" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "type" "Type" NOT NULL,
    "country" TEXT NOT NULL,
    "city" TEXT,
    "website" TEXT,
    "rankings" JSONB,

    CONSTRAINT "Provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Application" (
    "id" UUID NOT NULL,
    "userId" INTEGER NOT NULL,
    "scholarshipId" UUID NOT NULL,
    "status" "ApplicationStatus" NOT NULL,
    "notes" TEXT,
    "submittedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Application_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Application_userId_scholarshipId_key" ON "Application"("userId", "scholarshipId");

-- AddForeignKey
ALTER TABLE "Scholarship" ADD CONSTRAINT "Scholarship_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
