-- Migration to RBAC with JSONB
-- 1. Create Roles Table
CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  permissions JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Add role_id to Users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id);

-- 3. Pre-populate basic roles
INSERT INTO roles (name, permissions) VALUES 
('Super Admin', '{"all_access": true}')
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name, permissions) VALUES 
('Admin', '{"p_manage_permissions": true, "p_manage_users": true}')
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name, permissions) VALUES 
('Staff', '{}')
ON CONFLICT (name) DO NOTHING;

-- 4. Create a trigger to update 'updated_at' column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_roles_updated_at') THEN
        CREATE TRIGGER update_roles_updated_at BEFORE UPDATE
        ON roles FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
    END IF;
END $$;
