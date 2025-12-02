-- Table: users
CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT UNIQUE NOT NULL,
password TEXT NOT NULL -- in production: store hashed passwords
);


-- Table: places
CREATE TABLE places (
id INTEGER PRIMARY KEY,
title TEXT,
description TEXT,
image TEXT,
lat REAL,
lng REAL,
category TEXT,
visits INTEGER DEFAULT 0
);