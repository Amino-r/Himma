/*
  Warnings:

  - The `fields` column on the `Scholarship` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `type` on the `Provider` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Made the column `dateOfBirth` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "ProviderType" AS ENUM ('UNIVERSITY', 'GOVERNMENT', 'NGO', 'FOUNDATION');

-- CreateEnum
CREATE TYPE "ContentStatus" AS ENUM ('VISIBLE', 'HIDDEN', 'DELETED');

-- AlterTable
ALTER TABLE "Provider" DROP COLUMN "type",
ADD COLUMN     "type" "ProviderType" NOT NULL;

-- AlterTable
ALTER TABLE "Scholarship" ADD COLUMN     "guideId" UUID,
ALTER COLUMN "acceptsExpiredDocuments" SET DEFAULT false,
DROP COLUMN "fields",
ADD COLUMN     "fields" "FieldOfStudy"[];

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "highestEducationLevel" DROP NOT NULL,
ALTER COLUMN "dateOfBirth" SET NOT NULL;

-- DropEnum
DROP TYPE "Type";

-- CreateTable
CREATE TABLE "Post" (
    "id" UUID NOT NULL,
    "authorId" INTEGER NOT NULL,
    "scholarshipId" UUID,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "status" "ContentStatus" NOT NULL DEFAULT 'VISIBLE',
    "acceptedCommentId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" UUID NOT NULL,
    "postId" UUID NOT NULL,
    "authorId" INTEGER NOT NULL,
    "parentId" UUID,
    "body" TEXT NOT NULL,
    "status" "ContentStatus" NOT NULL DEFAULT 'VISIBLE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Guide" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "portalName" TEXT NOT NULL,
    "portalUrl" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Guide_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GuideStep" (
    "id" UUID NOT NULL,
    "guideId" UUID NOT NULL,
    "order" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,

    CONSTRAINT "GuideStep_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Post_acceptedCommentId_key" ON "Post"("acceptedCommentId");

-- CreateIndex
CREATE INDEX "Post_scholarshipId_idx" ON "Post"("scholarshipId");

-- CreateIndex
CREATE INDEX "Post_authorId_idx" ON "Post"("authorId");

-- CreateIndex
CREATE INDEX "Comment_postId_idx" ON "Comment"("postId");

-- CreateIndex
CREATE INDEX "Comment_parentId_idx" ON "Comment"("parentId");

-- CreateIndex
CREATE INDEX "GuideStep_guideId_idx" ON "GuideStep"("guideId");

-- AddForeignKey
ALTER TABLE "Scholarship" ADD CONSTRAINT "Scholarship_guideId_fkey" FOREIGN KEY ("guideId") REFERENCES "Guide"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_acceptedCommentId_fkey" FOREIGN KEY ("acceptedCommentId") REFERENCES "Comment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Comment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuideStep" ADD CONSTRAINT "GuideStep_guideId_fkey" FOREIGN KEY ("guideId") REFERENCES "Guide"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
