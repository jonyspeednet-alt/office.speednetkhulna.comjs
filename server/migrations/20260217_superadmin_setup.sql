-- Ensure Super Admin role exists with full permissions
INSERT INTO roles (name, permissions) 
VALUES ('Super Admin', '{"all_access": true}')
ON CONFLICT (name) DO UPDATE SET permissions = '{"all_access": true}';

-- Assign the Super Admin role to user with employee_id 'SN-01'
-- 1. Identify role_id for Super Admin
-- 2. Update the user record
UPDATE users 
SET role_id = (SELECT id FROM roles WHERE name = 'Super Admin'),
    role = 'Super Admin' -- Optional: legacy field sync
WHERE employee_id = 'SN-01';

-- Update the user_permissions table as well for SN-01 to ensure full compatibility
-- Clear existing specific permissions as 'all_access' is now the way.
-- DELETE FROM user_permissions WHERE user_id = (SELECT id FROM users WHERE employee_id = 'SN-01');
