-- -------------------------------------------------------------
-- TablePlus 4.6.6(422)
--
-- https://tableplus.com/
--
-- Database: quality-bot
-- Generation Time: 2022-05-15 3:33:37.8030 PM
-- -------------------------------------------------------------


DROP TABLE IF EXISTS "public"."_prisma_migrations";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."_prisma_migrations" (
    "id" varchar(36) NOT NULL,
    "checksum" varchar(64) NOT NULL,
    "finished_at" timestamptz,
    "migration_name" varchar(255) NOT NULL,
    "logs" text,
    "rolled_back_at" timestamptz,
    "started_at" timestamptz NOT NULL DEFAULT now(),
    "applied_steps_count" int4 NOT NULL DEFAULT 0,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."ChannelBinding";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS "ChannelBinding_id_seq";
DROP TYPE IF EXISTS "public"."Command";
CREATE TYPE "public"."Command" AS ENUM ('FILECONVERTER', 'REMINDER', 'MUSIC');

-- Table Definition
CREATE TABLE "public"."ChannelBinding" (
    "id" int4 NOT NULL DEFAULT nextval('"ChannelBinding_id_seq"'::regclass),
    "guildId" text NOT NULL,
    "channelId" text NOT NULL,
    "bindedCommand" "public"."Command" NOT NULL,
    "createdAt" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp(3) NOT NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."Reminder";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS "Reminder_id_seq";

-- Table Definition
CREATE TABLE "public"."Reminder" (
    "id" int4 NOT NULL DEFAULT nextval('"Reminder_id_seq"'::regclass),
    "name" text NOT NULL,
    "remindAt" timestamp(3) NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp(3) NOT NULL,
    "guildId" text NOT NULL,
    PRIMARY KEY ("id")
);

