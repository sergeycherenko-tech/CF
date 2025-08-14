-- PostgreSQL schema for Cash Flow service
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  iban_or_number TEXT NOT NULL,
  bank_name TEXT,
  currency TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS imports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  source TEXT,
  filename TEXT,
  parser TEXT,
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  rows_ingested INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'done',
  log TEXT
);

CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  account_id UUID REFERENCES accounts(id) ON DELETE SET NULL,
  import_batch_id UUID REFERENCES imports(id) ON DELETE SET NULL,
  op_date DATE NOT NULL,
  value_date DATE,
  amount NUMERIC(18,2) NOT NULL,
  currency TEXT,
  description_raw TEXT,
  counterparty_name TEXT,
  op_type TEXT,
  doc_in_number TEXT,
  act_date DATE,
  lvl1 TEXT,
  lvl2 TEXT,
  lvl3 TEXT,
  tags JSONB,
  receipt_sent BOOLEAN,
  receipt_number TEXT,
  exclude_from_cf BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_transactions_company_date ON transactions(company_id, op_date);
CREATE INDEX IF NOT EXISTS idx_transactions_company_lvl ON transactions(company_id, lvl2, lvl3, op_date);
CREATE INDEX IF NOT EXISTS idx_transactions_account_date ON transactions(account_id, op_date);
CREATE INDEX IF NOT EXISTS idx_transactions_import ON transactions(import_batch_id);

CREATE TABLE IF NOT EXISTS rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  priority INT NOT NULL,
  description TEXT,
  condition_json JSONB NOT NULL,
  action_json JSONB NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_rules_company_priority ON rules(company_id, priority);

CREATE TABLE IF NOT EXISTS planned_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  due_date DATE NOT NULL,
  amount NUMERIC(18,2) NOT NULL,
  currency TEXT,
  counterparty_name TEXT,
  lvl2 TEXT,
  lvl3 TEXT,
  status TEXT NOT NULL DEFAULT 'planned',
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_plan_company_date ON planned_payments(company_id, due_date);

CREATE TABLE IF NOT EXISTS period_buckets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bucket_start DATE NOT NULL,
  bucket_end DATE,
  label TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_buckets_start ON period_buckets(bucket_start);

CREATE TABLE IF NOT EXISTS settings (
  company_id UUID PRIMARY KEY REFERENCES companies(id) ON DELETE CASCADE,
  opening_balance_mode TEXT NOT NULL DEFAULT 'from_uk',
  opening_balance_value NUMERIC(18,2) NOT NULL DEFAULT 0
);
