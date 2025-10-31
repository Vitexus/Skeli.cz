-- Promote skelimc to ADMIN role (idempotent)
UPDATE users SET role='ADMIN' WHERE username='skelimc';
