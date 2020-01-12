-- Create a new table called 'chat_group' in schema 'chat'
-- Drop the table if it already exists
IF OBJECT_ID('chat.chat_group', 'U') IS NOT NULL
DROP TABLE chat.chat_group
GO
-- Create the table in the specified schema
CREATE TABLE chat.chat_group
(
    id INT NOT NULL PRIMARY KEY,
    -- primary key column
    name VARCHAR(255) NOT NULL,
    -- specify more columns here
);
GO

-- Create a new table called 'chat_msg' in schema 'chat'
-- Drop the table if it already exists
IF OBJECT_ID('chat.chat_msg', 'U') IS NOT NULL
DROP TABLE chat.chat_msg
GO
-- Create the table in the specified schema
CREATE TABLE chat.chat_msg
(
    id INT NOT NULL PRIMARY KEY,
    -- primary key column
    msg VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    group_Id INT NOT NULL,
    type TINYINT NOT NULL,
    -- specify more columns here
);
GO

-- Create a new table called 'chat_user' in schema 'chat'
-- Drop the table if it already exists
IF OBJECT_ID('chat.chat_user', 'U') IS NOT NULL
DROP TABLE chat.chat_user
GO
-- Create the table in the specified schema
CREATE TABLE chat.chat_user
(
    id INT NOT NULL PRIMARY KEY,
    -- primary key column
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
    -- specify more columns here
);
GO

-- Create a new table called 'chat_user_group' in schema 'chat'
-- Drop the table if it already exists
IF OBJECT_ID('chat.chat_user_group', 'U') IS NOT NULL
DROP TABLE chat.chat_user_group
GO
-- Create the table in the specified schema
CREATE TABLE chat.chat_user_group
(
    id INT NOT NULL PRIMARY KEY,
    -- primary key column
    user_id INT NOT NULL,
    group_id INT NOT NULL
    -- specify more columns here
);
GO